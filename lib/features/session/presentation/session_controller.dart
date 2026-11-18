import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../../core/providers.dart';
import '../domain/session_cursor.dart';
import '../domain/session_plan.dart';
import '../domain/session_summary.dart';
import '../domain/set_entry.dart';

/// Sessão em andamento, já reidratada do banco.
class ActiveSessionView {
  const ActiveSessionView({
    required this.session,
    required this.plan,
    required this.logs,
  });

  final Session session;
  final SessionPlan plan;
  final List<SetLog> logs;

  SessionCursor get cursor =>
      SessionCursor(session.cursorExercise, session.cursorSet);

  PlanExercise get currentExercise => plan.exercises[cursor.exerciseIndex];

  int doneSetsOf(int exerciseIndex) =>
      logs.where((l) => l.exerciseIndex == exerciseIndex).length;
}

class SessionState {
  const SessionState({
    this.active,
    this.sheet,
    this.summary,
    this.stalePrompt = false,
  });

  final ActiveSessionView? active;

  /// Não-nulo = janela de registro aberta.
  final SheetData? sheet;

  /// Não-nulo = mostrar a tela de resumo do treino recém-encerrado.
  final SessionSummary? summary;

  /// Sessão esquecida aberta (> 3 h): perguntar se continua ou encerra.
  final bool stalePrompt;

  bool get hasActive => active != null;
}

const staleThreshold = Duration(hours: 3);

final sessionControllerProvider =
    AsyncNotifierProvider<WorkoutSessionController, SessionState>(
      WorkoutSessionController.new,
    );

class WorkoutSessionController extends AsyncNotifier<SessionState> {
  Future<void> _lock = Future.value();
  final Set<int> _staleAcknowledged = {};
  bool _sheetAfterStale = false;

  DateTime get _now => ref.read(clockProvider)();

  @override
  Future<SessionState> build() => _load(keepSheet: false);

  /// Executa operações uma de cada vez (gatilho + resume + OK não se cruzam).
  Future<T> _serial<T>(Future<T> Function() op) {
    final completer = Completer<T>();
    _lock = _lock.then((_) async {
      try {
        completer.complete(await op());
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });
    return completer.future;
  }

  SessionState get _current => state.value ?? const SessionState();

  Future<SessionState> _load({bool keepSheet = true}) async {
    final repo = ref.read(sessionRepositoryProvider);
    final previous = state.value;
    final s = await repo.activeSession();
    if (s == null) {
      return SessionState(summary: previous?.summary);
    }
    final view = ActiveSessionView(
      session: s,
      plan: SessionPlan.decode(s.planJson),
      logs: await repo.logsOf(s.id),
    );
    final lastActivity = s.lastSetAt ?? s.startedAt;
    final stale =
        _now.difference(lastActivity) > staleThreshold &&
        !_staleAcknowledged.contains(s.id);
    SheetData? sheet;
    if (keepSheet && previous?.sheet != null && !stale) {
      // Mantém a janela só se ainda aponta para a série certa.
      sheet = previous!.sheet!.cursor == view.cursor
          ? previous.sheet
          : await _sheetFor(view);
    }
    return SessionState(active: view, sheet: sheet, stalePrompt: stale);
  }

  Future<SheetData> _sheetFor(ActiveSessionView view) async {
    final repo = ref.read(sessionRepositoryProvider);
    final ex = view.currentExercise;
    final lastTime = ex.isWarmup
        ? <SetLog>[]
        : await repo.lastTimeSets(ex.exerciseId, view.session.id);
    return buildSheetData(
      plan: view.plan,
      cursor: view.cursor,
      sessionLogs: view.logs,
      lastTimeLogs: lastTime,
    );
  }

  /// Recarrega a sessão do banco (ex.: ao voltar para o primeiro plano).
  Future<void> reload() => _serial(() async {
    state = AsyncData(await _load());
  });

  Future<void> start(int templateId) => _serial(() async {
    final repo = ref.read(sessionRepositoryProvider);
    await repo.startSession(templateId: templateId, now: _now);
    unawaited(ref.read(notificationServiceProvider).requestPermission());
    state = AsyncData(await _load(keepSheet: false));
  });

  /// Ponto único de entrada do toque duplo, do App Intent e do botão
  /// "Registrar série". Sempre recarrega do banco antes de agir.
  Future<void> onRegisterTrigger({bool external = false}) => _serial(() async {
    if (external) ref.read(externalTriggerHookProvider)();
    final loaded = await _load();
    final view = loaded.active;
    if (view == null) {
      state = AsyncData(loaded);
      return;
    }
    if (loaded.stalePrompt) {
      _sheetAfterStale = true;
      state = AsyncData(loaded);
      return;
    }
    state = AsyncData(
      SessionState(active: view, sheet: loaded.sheet ?? await _sheetFor(view)),
    );
  });

  /// Fecha a janela sem registrar.
  void closeSheet() {
    final s = _current;
    state = AsyncData(SessionState(active: s.active, summary: s.summary));
  }

  /// OK na janela: grava, avança o cursor e agenda o fim do descanso.
  Future<void> confirmSet(SetEntry entry) {
    // Cursor da janela no momento do toque: um segundo OK para a mesma
    // janela chega com um cursor que o banco já passou e é descartado.
    final expected = _current.sheet?.cursor;
    if (expected == null) return Future.value();
    return _serial(() async {
      final repo = ref.read(sessionRepositoryProvider);
      final notifications = ref.read(notificationServiceProvider);
      final fresh = await repo.activeSession();
      if (fresh == null) {
        state = AsyncData(await _load(keepSheet: false));
        return;
      }
      if (expected != SessionCursor(fresh.cursorExercise, fresh.cursorSet)) {
        state = AsyncData(await _load(keepSheet: false));
        return;
      }
      final result = await repo.logSet(
        sessionId: fresh.id,
        entry: entry,
        now: _now,
      );
      await notifications.cancelRestEnd();
      if (result.finished) {
        final summary = await repo.summary(fresh.id);
        state = AsyncData(SessionState(summary: summary));
        return;
      }
      final loaded = await _load(keepSheet: false);
      if (result.restEndsAt != null && loaded.active != null) {
        final next = loaded.active!;
        unawaited(
          notifications.scheduleRestEnd(
            result.restEndsAt!,
            body:
                'Próximo: ${next.currentExercise.name} — série ${next.cursor.setIndex + 1} de ${next.currentExercise.sets}',
          ),
        );
      }
      state = AsyncData(loaded);
    });
  }

  Future<void> undoLast() => _serial(() async {
    final s = _current.active;
    if (s == null) return;
    await ref.read(sessionRepositoryProvider).undoLast(s.session.id);
    await ref.read(notificationServiceProvider).cancelRestEnd();
    state = AsyncData(await _load(keepSheet: false));
  });

  Future<void> skipExercise() => _serial(() async {
    final s = _current.active;
    if (s == null) return;
    final repo = ref.read(sessionRepositoryProvider);
    final finished = await repo.skipExercise(s.session.id, _now);
    await ref.read(notificationServiceProvider).cancelRestEnd();
    if (finished) {
      state = AsyncData(
        SessionState(summary: await repo.summary(s.session.id)),
      );
    } else {
      state = AsyncData(await _load(keepSheet: false));
    }
  });

  Future<void> finishManually() => _serial(() async {
    final s = _current.active;
    if (s == null) return;
    final repo = ref.read(sessionRepositoryProvider);
    await repo.finish(s.session.id, _now);
    await ref.read(notificationServiceProvider).cancelRestEnd();
    state = AsyncData(SessionState(summary: await repo.summary(s.session.id)));
  });

  void dismissSummary() {
    state = AsyncData(SessionState(active: _current.active));
  }

  /// Sessão esquecida: continuar de onde parou.
  Future<void> continueStale() => _serial(() async {
    final s = _current.active;
    if (s == null) return;
    _staleAcknowledged.add(s.session.id);
    final loaded = await _load(keepSheet: false);
    final openSheet = _sheetAfterStale && loaded.active != null;
    _sheetAfterStale = false;
    state = AsyncData(
      openSheet
          ? SessionState(
              active: loaded.active,
              sheet: await _sheetFor(loaded.active!),
            )
          : loaded,
    );
  });

  /// Sessão esquecida: encerrar no horário da última série.
  Future<void> closeStale() => _serial(() async {
    final s = _current.active;
    if (s == null) return;
    _sheetAfterStale = false;
    final repo = ref.read(sessionRepositoryProvider);
    await repo.closeStale(s.session.id);
    await ref.read(notificationServiceProvider).cancelRestEnd();
    state = AsyncData(await _load(keepSheet: false));
  });
}
