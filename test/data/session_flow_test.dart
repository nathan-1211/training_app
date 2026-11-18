import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:training/core/db/database.dart';
import 'package:training/core/providers.dart';
import 'package:training/core/services/notification_service.dart';
import 'package:training/features/blocks/data/block_repository.dart';
import 'package:training/features/session/data/session_repository.dart';
import 'package:training/features/session/domain/session_cursor.dart';
import 'package:training/features/session/domain/set_entry.dart';
import 'package:training/features/session/presentation/session_controller.dart';
import 'package:training/features/trigger/data/trigger_service.dart';

import '../helpers.dart';

Future<int> forcaAId(AppDatabase db) async {
  final repo = BlockRepository(db);
  final block = (await repo.activeBlock())!;
  return (await repo.templatesOf(block.id)).first.id;
}

/// Repositório cujo primeiro acesso ao banco fica travado até [gate] abrir
/// — simula o cold start com o banco ainda carregando.
class SlowSessionRepository extends SessionRepository {
  SlowSessionRepository(super.db, this.gate);
  final Completer<void> gate;

  @override
  Future<Session?> activeSession() async {
    await gate.future;
    return super.activeSession();
  }
}

class FakeSources implements TriggerSources {
  FakeSources({this.initial});
  final Uri? initial;
  final stream = StreamController<Uri>.broadcast();
  final intents = <String>[];
  void Function()? _intentListener;

  @override
  Stream<Uri> get linkStream => stream.stream;
  @override
  Future<Uri?> initialLink() async => initial;
  @override
  Future<List<String>> consumeIntentTriggers() async {
    final out = List<String>.from(intents);
    intents.clear();
    return out;
  }

  @override
  void setIntentListener(void Function() onAvailable) =>
      _intentListener = onAvailable;

  void fireIntent(String id) {
    intents.add(id);
    _intentListener?.call();
  }
}

void main() {
  late AppDatabase db;
  setUp(() => db = memoryDb());
  tearDown(() => db.close());

  test(
    'fluxo completo: Força A semana 1 = 18 séries e termina sozinho',
    () async {
      final clock = TestClock(mondayW1);
      final notifications = NoopNotificationService();
      final c = makeContainer(db, clock: clock, notifications: notifications);
      final ctrl = c.read(sessionControllerProvider.notifier);
      await c.read(sessionControllerProvider.future);

      await ctrl.start(await forcaAId(db));
      var s = c.read(sessionControllerProvider).value!;
      expect(s.active!.cursor, SessionCursor.start);
      expect(s.active!.plan.totalSets, 18);

      var count = 0;
      while (c.read(sessionControllerProvider).value!.active != null) {
        await ctrl.onRegisterTrigger();
        final sheet = c.read(sessionControllerProvider).value!.sheet!;
        clock.advance(const Duration(minutes: 2));
        await ctrl.confirmSet(
          SetEntry(
            loadKg: sheet.logType.hasLoad ? 40 : null,
            reps: sheet.prefillReps,
            distanceM: sheet.prefillDistance,
          ),
        );
        count++;
      }
      expect(count, 18);
      s = c.read(sessionControllerProvider).value!;
      expect(s.summary, isNotNull);
      expect(s.summary!.setCount, 18);
      // 6 principais × 2 séries; volume = soma de 40 × reps alvo.
      expect(s.summary!.totalVolumeKg, greaterThan(0));
      // Descanso agendado a cada série principal (não-final), cancelado a cada OK.
      expect(notifications.scheduled, isNotEmpty);
      expect(notifications.cancels, 18);
    },
  );

  test('retomada: novo processo reidrata a sessão na série certa', () async {
    final clock = TestClock(mondayW1);
    final c1 = makeContainer(db, clock: clock);
    final ctrl1 = c1.read(sessionControllerProvider.notifier);
    await c1.read(sessionControllerProvider.future);
    await ctrl1.start(await forcaAId(db));
    // Aquecimentos (3 × 2) + 1ª série do terra.
    for (var i = 0; i < 7; i++) {
      await ctrl1.onRegisterTrigger();
      await ctrl1.confirmSet(const SetEntry(loadKg: 60, reps: 8));
      clock.advance(const Duration(seconds: 30));
    }
    c1.dispose(); // iOS encerrou o app

    clock.advance(const Duration(minutes: 2));
    final c2 = makeContainer(db, clock: clock);
    final s = await c2.read(sessionControllerProvider.future);
    expect(s.active, isNotNull);
    expect(s.active!.cursor, const SessionCursor(3, 1));
    expect(s.active!.currentExercise.name, 'Terra com trap bar');
    expect(s.stalePrompt, isFalse);

    await c2.read(sessionControllerProvider.notifier).onRegisterTrigger();
    final sheet = c2.read(sessionControllerProvider).value!.sheet!;
    expect(sheet.setNumber, 2);
    expect(sheet.totalSets, 2);
    expect(sheet.prefillLoad, 60); // carga da série anterior desta sessão
    expect(sheet.goalText, '6–8 reps · RIR 3–4');
  });

  test('pré-preenche com a última sessão e mostra "última vez"', () async {
    final clock = TestClock(mondayW1);
    final c = makeContainer(db, clock: clock);
    final ctrl = c.read(sessionControllerProvider.notifier);
    await c.read(sessionControllerProvider.future);
    final id = await forcaAId(db);
    await ctrl.start(id);
    for (var i = 0; i < 7; i++) {
      await ctrl.onRegisterTrigger();
      await ctrl.confirmSet(const SetEntry(loadKg: 70, reps: 7));
    }
    await ctrl.finishManually();
    ctrl.dismissSummary();

    clock.advance(const Duration(days: 7));
    await ctrl.start(id);
    await ctrl.skipExercise();
    await ctrl.skipExercise();
    await ctrl.skipExercise();
    await ctrl.onRegisterTrigger();
    final sheet = c.read(sessionControllerProvider).value!.sheet!;
    expect(sheet.exercise.name, 'Terra com trap bar');
    expect(sheet.prefillLoad, 70);
    expect(sheet.lastTimeText, '70 kg × 7');
    expect(sheet.prefillReps, 8); // alvo (máx. da faixa)
  });

  test('desfazer volta o cursor; OK duplicado não grava duas vezes', () async {
    final c = makeContainer(db);
    final ctrl = c.read(sessionControllerProvider.notifier);
    await c.read(sessionControllerProvider.future);
    await ctrl.start(await forcaAId(db));
    await ctrl.onRegisterTrigger();
    // Dois OKs para a mesma janela (toque duplo no botão).
    await Future.wait([
      ctrl.confirmSet(const SetEntry()),
      ctrl.confirmSet(const SetEntry()),
    ]);
    var s = c.read(sessionControllerProvider).value!;
    expect(s.active!.logs.length, 1);
    expect(s.active!.cursor, const SessionCursor(0, 1));
    await ctrl.undoLast();
    s = c.read(sessionControllerProvider).value!;
    expect(s.active!.logs, isEmpty);
    expect(s.active!.cursor, SessionCursor.start);
  });

  test('sessão esquecida (> 3 h) pergunta antes de abrir a janela', () async {
    final clock = TestClock(mondayW1);
    final c = makeContainer(db, clock: clock);
    final ctrl = c.read(sessionControllerProvider.notifier);
    await c.read(sessionControllerProvider.future);
    await ctrl.start(await forcaAId(db));
    await ctrl.onRegisterTrigger();
    await ctrl.confirmSet(const SetEntry());

    clock.advance(const Duration(hours: 3, minutes: 1));
    await ctrl.onRegisterTrigger();
    var s = c.read(sessionControllerProvider).value!;
    expect(s.stalePrompt, isTrue);
    expect(s.sheet, isNull);

    await ctrl.continueStale();
    s = c.read(sessionControllerProvider).value!;
    expect(s.stalePrompt, isFalse);
    expect(s.sheet, isNotNull); // o gatilho pendente abre a janela
    expect(s.sheet!.cursor, const SessionCursor(0, 1));
  });

  test('encerrar sessão esquecida fecha no horário da última série', () async {
    final clock = TestClock(mondayW1);
    final c = makeContainer(db, clock: clock);
    final ctrl = c.read(sessionControllerProvider.notifier);
    await c.read(sessionControllerProvider.future);
    await ctrl.start(await forcaAId(db));
    await ctrl.onRegisterTrigger();
    await ctrl.confirmSet(const SetEntry());
    clock.advance(const Duration(hours: 5));
    await ctrl.reload();
    expect(c.read(sessionControllerProvider).value!.stalePrompt, isTrue);
    await ctrl.closeStale();
    expect(c.read(sessionControllerProvider).value!.active, isNull);
    final s = await (db.select(db.sessions)).getSingle();
    expect(s.endedAt, mondayW1);
  });

  test('cold start: gatilho chega com o banco carregando, é enfileirado e '
      'processado uma vez só (link inicial + stream)', () async {
    // Sessão em andamento deixada por um processo anterior.
    final clock = TestClock(mondayW1);
    final c1 = makeContainer(db, clock: clock);
    final ctrl1 = c1.read(sessionControllerProvider.notifier);
    await c1.read(sessionControllerProvider.future);
    await ctrl1.start(await forcaAId(db));
    for (var i = 0; i < 2; i++) {
      await ctrl1.onRegisterTrigger();
      await ctrl1.confirmSet(const SetEntry());
    }
    c1.dispose();

    // Novo processo: banco "lento".
    final gate = Completer<void>();
    var hookCalls = 0;
    final c2 = makeContainer(
      db,
      clock: clock,
      onExternalTrigger: () => hookCalls++,
      overrides: [
        sessionRepositoryProvider.overrideWith(
          (ref) => SlowSessionRepository(db, gate),
        ),
      ],
    );
    final link = Uri.parse('treino://registrar');
    final sources = FakeSources(initial: link);
    final service = TriggerService(c2, sources);
    final started = service.start();
    // O plugin do iOS reenvia o link de abertura pelo stream.
    sources.stream.add(link);
    await Future<void>.delayed(Duration.zero);

    expect(service.queue.isReady, isFalse);
    expect(service.queue.hasPending, isTrue);
    expect(service.queue.processedCount, 0);

    gate.complete(); // banco pronto
    await started;
    await service.queue.idle;

    expect(service.queue.processedCount, 1);
    expect(hookCalls, 1);
    final s = c2.read(sessionControllerProvider).value!;
    expect(s.sheet, isNotNull);
    expect(
      s.sheet!.cursor,
      const SessionCursor(1, 0),
    ); // 2º aquecimento, série 1
    await service.dispose();
  });

  test('app suspenso: gatilho pelo stream e pelo App Intent', () async {
    final c = makeContainer(db);
    final ctrl = c.read(sessionControllerProvider.notifier);
    final sources = FakeSources();
    final service = TriggerService(c, sources);
    await service.start();
    await ctrl.start(await forcaAId(db));

    sources.stream.add(Uri.parse('treino://registrar'));
    await Future<void>.delayed(Duration.zero);
    await service.queue.idle;
    expect(c.read(sessionControllerProvider).value!.sheet, isNotNull);
    ctrl.closeSheet();

    sources.fireIntent('uuid-1');
    await Future<void>.delayed(Duration.zero);
    await service.queue.idle;
    expect(c.read(sessionControllerProvider).value!.sheet, isNotNull);
    expect(service.queue.processedCount, 2);

    // Link de outro tipo é ignorado.
    sources.stream.add(Uri.parse('treino://outra-coisa'));
    await Future<void>.delayed(Duration.zero);
    expect(service.queue.processedCount, 2);
    await service.dispose();
  });

  test('gatilho sem treino em andamento não abre janela', () async {
    final c = makeContainer(db);
    final ctrl = c.read(sessionControllerProvider.notifier);
    await c.read(sessionControllerProvider.future);
    await ctrl.onRegisterTrigger(external: true);
    final s = c.read(sessionControllerProvider).value!;
    expect(s.active, isNull);
    expect(s.sheet, isNull);
  });
}
