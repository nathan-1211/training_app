import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/enums.dart';
import '../../blocks/data/block_repository.dart';
import '../../blocks/domain/block_generator.dart';
import '../../dashboard/domain/strength_math.dart';
import '../domain/rest_timer.dart';
import '../domain/session_cursor.dart';
import '../domain/session_plan.dart';
import '../domain/session_summary.dart';
import '../domain/set_entry.dart';

class LogSetResult {
  const LogSetResult({required this.finished, this.restEndsAt});
  final bool finished;
  final DateTime? restEndsAt;
}

class SessionRepository {
  SessionRepository(this.db);
  final AppDatabase db;

  Future<Session?> activeSession() =>
      (db.select(db.sessions)
            ..where((s) => s.status.equalsValue(SessionStatus.active))
            ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<Session> byId(int id) =>
      (db.select(db.sessions)..where((s) => s.id.equals(id))).getSingle();

  /// Plano da sessão a partir do template e da semana do bloco.
  Future<SessionPlan> buildPlan(int templateId, BlockWeek? week) async {
    final rows = await BlockRepository(db).templateExercises(templateId);
    final mainSets = week?.mainSets ?? 3;
    return SessionPlan([
      for (final r in rows)
        PlanExercise(
          exerciseId: r.exercise.id,
          name: r.exercise.name,
          logType: r.te.logType,
          isWarmup: r.te.isWarmup,
          sets: r.te.fixedSets ?? (r.te.isWarmup ? 2 : mainSets),
          repsText: r.te.repsText,
          repsMin: r.te.repsMin,
          repsMax: r.te.repsMax,
          rir: week?.rir ?? '',
          restSec: r.te.restSec,
          tip: r.te.tip,
        ),
    ]);
  }

  /// Cria a sessão com o cursor no exercício 1, série 1.
  Future<int> startSession({required int templateId, required DateTime now}) {
    return db.transaction(() async {
      final active = await activeSession();
      if (active != null) return active.id;
      final template = await (db.select(
        db.workoutTemplates,
      )..where((t) => t.id.equals(templateId))).getSingle();
      final block = await (db.select(
        db.blocks,
      )..where((b) => b.id.equals(template.blockId))).getSingle();
      final week =
          blockWeekFor(
            startDate: block.startDate,
            weeks: block.weeks,
            date: now,
          ) ??
          (now.isBefore(block.startDate) ? 1 : block.weeks);
      final weekRow = await BlockRepository(db).weekRow(block.id, week);
      final plan = await buildPlan(templateId, weekRow);
      final first =
          CursorLogic.normalize(plan, SessionCursor.start) ??
          SessionCursor.start;
      return db
          .into(db.sessions)
          .insert(
            SessionsCompanion.insert(
              blockId: Value(block.id),
              templateId: Value(templateId),
              templateName: template.name,
              weekNumber: Value(week),
              planJson: plan.encode(),
              status: SessionStatus.active,
              startedAt: now,
              cursorExercise: Value(first.exerciseIndex),
              cursorSet: Value(first.setIndex),
            ),
          );
    });
  }

  Future<List<SetLog>> logsOf(int sessionId) =>
      (db.select(db.setLogs)
            ..where((l) => l.sessionId.equals(sessionId))
            ..orderBy([
              (l) => OrderingTerm.asc(l.createdAt),
              (l) => OrderingTerm.asc(l.id),
            ]))
          .get();

  /// Séries do exercício na sessão mais recente (diferente de [excludeSessionId])
  /// em que ele foi registrado.
  Future<List<SetLog>> lastTimeSets(
    int exerciseId,
    int excludeSessionId,
  ) async {
    final last =
        await (db.select(db.setLogs)
              ..where(
                (l) =>
                    l.exerciseId.equals(exerciseId) &
                    l.sessionId.equals(excludeSessionId).not(),
              )
              ..orderBy([(l) => OrderingTerm.desc(l.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (last == null) return [];
    return (db.select(db.setLogs)
          ..where(
            (l) =>
                l.exerciseId.equals(exerciseId) &
                l.sessionId.equals(last.sessionId),
          )
          ..orderBy([(l) => OrderingTerm.asc(l.setIndex)]))
        .get();
  }

  /// Grava a série no cursor atual e avança — tudo numa transação.
  Future<LogSetResult> logSet({
    required int sessionId,
    required SetEntry entry,
    required DateTime now,
  }) {
    return db.transaction(() async {
      final s = await byId(sessionId);
      final plan = SessionPlan.decode(s.planJson);
      final cursor = SessionCursor(s.cursorExercise, s.cursorSet);
      final ex = plan.exercises[cursor.exerciseIndex];
      await db
          .into(db.setLogs)
          .insert(
            SetLogsCompanion.insert(
              sessionId: sessionId,
              exerciseId: ex.exerciseId,
              exerciseIndex: cursor.exerciseIndex,
              setIndex: cursor.setIndex,
              loadKg: Value(entry.loadKg),
              reps: Value(entry.reps),
              distanceM: Value(entry.distanceM),
              durationSec: Value(entry.durationSec),
              isWarmup: Value(ex.isWarmup),
              createdAt: now,
            ),
          );
      final next = CursorLogic.advance(plan, cursor);
      if (next == null) {
        await _finish(sessionId, now, lastSetAt: now);
        return const LogSetResult(finished: true);
      }
      final restEnd = RestTimer.endsAt(now, ex.restSec);
      await (db.update(
        db.sessions,
      )..where((x) => x.id.equals(sessionId))).write(
        SessionsCompanion(
          cursorExercise: Value(next.exerciseIndex),
          cursorSet: Value(next.setIndex),
          lastSetAt: Value(now),
          restEndsAt: Value(restEnd),
        ),
      );
      return LogSetResult(finished: false, restEndsAt: restEnd);
    });
  }

  /// Remove a última série e volta o cursor para ela.
  Future<bool> undoLast(int sessionId) {
    return db.transaction(() async {
      final logs = await logsOf(sessionId);
      if (logs.isEmpty) return false;
      final last = logs.last;
      await (db.delete(db.setLogs)..where((l) => l.id.equals(last.id))).go();
      final prev = logs.length > 1 ? logs[logs.length - 2] : null;
      await (db.update(
        db.sessions,
      )..where((x) => x.id.equals(sessionId))).write(
        SessionsCompanion(
          cursorExercise: Value(last.exerciseIndex),
          cursorSet: Value(last.setIndex),
          lastSetAt: Value(prev?.createdAt),
          restEndsAt: const Value(null),
          status: const Value(SessionStatus.active),
          endedAt: const Value(null),
        ),
      );
      return true;
    });
  }

  /// Pula o exercício atual. Retorna true se o treino terminou.
  Future<bool> skipExercise(int sessionId, DateTime now) {
    return db.transaction(() async {
      final s = await byId(sessionId);
      final plan = SessionPlan.decode(s.planJson);
      final next = CursorLogic.skipExercise(
        plan,
        SessionCursor(s.cursorExercise, s.cursorSet),
      );
      if (next == null) {
        await _finish(sessionId, now);
        return true;
      }
      await (db.update(
        db.sessions,
      )..where((x) => x.id.equals(sessionId))).write(
        SessionsCompanion(
          cursorExercise: Value(next.exerciseIndex),
          cursorSet: Value(next.setIndex),
          restEndsAt: const Value(null),
        ),
      );
      return false;
    });
  }

  Future<void> finish(int sessionId, DateTime now) => _finish(sessionId, now);

  Future<void> _finish(
    int sessionId,
    DateTime now, {
    DateTime? lastSetAt,
  }) async {
    await (db.update(db.sessions)..where((x) => x.id.equals(sessionId))).write(
      SessionsCompanion(
        status: const Value(SessionStatus.finished),
        endedAt: Value(now),
        restEndsAt: const Value(null),
        lastSetAt: lastSetAt == null ? const Value.absent() : Value(lastSetAt),
      ),
    );
  }

  /// Encerrar uma sessão esquecida: termina no horário da última série.
  Future<void> closeStale(int sessionId) async {
    final s = await byId(sessionId);
    final logs = await logsOf(sessionId);
    if (logs.isEmpty) {
      await (db.delete(db.sessions)..where((x) => x.id.equals(sessionId))).go();
      return;
    }
    await _finish(sessionId, s.lastSetAt ?? logs.last.createdAt);
  }

  Future<SessionSummary> summary(int sessionId) async {
    final s = await byId(sessionId);
    final logs = await logsOf(sessionId);
    final plan = SessionPlan.decode(s.planJson);
    final ids = logs.map((l) => l.exerciseId).toSet();
    final previous = <int, ({double load, double e1rm})>{};
    if (ids.isNotEmpty) {
      final prevLogs =
          await (db.select(db.setLogs)..where(
                (l) =>
                    l.exerciseId.isIn(ids) &
                    l.sessionId.equals(sessionId).not() &
                    l.loadKg.isNotNull() &
                    l.isWarmup.equals(false),
              ))
              .get();
      for (final id in ids) {
        final mine = prevLogs.where((l) => l.exerciseId == id).toList();
        if (mine.isEmpty) continue;
        final sets = mine
            .where((l) => l.reps != null)
            .map((l) => LoadedSet(l.loadKg!, l.reps!));
        previous[id] = (
          load: mine.fold(0.0, (m, l) => l.loadKg! > m ? l.loadKg! : m),
          e1rm: bestE1RM(sets),
        );
      }
    }
    return buildSummary(
      session: s,
      plan: plan,
      logs: logs,
      previousBest: previous,
    );
  }
}
