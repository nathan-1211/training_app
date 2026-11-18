import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/enums.dart';

class DashboardData {
  const DashboardData({
    required this.blocks,
    required this.block,
    required this.sessions,
    required this.logs,
    required this.cardio,
    required this.exercises,
    required this.planned,
    required this.assessments,
  });

  final List<Block> blocks;

  /// Bloco filtrado (null = todos os blocos).
  final Block? block;
  final List<Session> sessions;
  final List<SetLog> logs;
  final List<CardioLog> cardio;

  /// Exercícios principais com carga registrada.
  final List<Exercise> exercises;
  final List<PlannedSession> planned;
  final List<AssessmentResult> assessments;
}

class DashboardRepository {
  DashboardRepository(this.db);
  final AppDatabase db;

  Future<DashboardData> load({int? blockId}) async {
    final blocks = await (db.select(
      db.blocks,
    )..orderBy([(b) => OrderingTerm.desc(b.startDate)])).get();
    final block = blockId == null
        ? null
        : blocks.where((b) => b.id == blockId).firstOrNull;

    final sq = db.select(db.sessions)
      ..where((s) => s.status.equalsValue(SessionStatus.finished))
      ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]);
    if (block != null) sq.where((s) => s.blockId.equals(block.id));
    final sessions = await sq.get();
    final ids = sessions.map((s) => s.id).toList();
    final logs = ids.isEmpty
        ? <SetLog>[]
        : await (db.select(
            db.setLogs,
          )..where((l) => l.sessionId.isIn(ids))).get();

    final cq = db.select(db.cardioLogs)
      ..orderBy([(c) => OrderingTerm.asc(c.date)]);
    if (block != null) cq.where((c) => c.blockId.equals(block.id));
    final cardio = await cq.get();

    final exIds = logs
        .where((l) => !l.isWarmup && l.loadKg != null && l.reps != null)
        .map((l) => l.exerciseId)
        .toSet();
    final exercises = exIds.isEmpty
        ? <Exercise>[]
        : await (db.select(db.exercises)
                ..where((e) => e.id.isIn(exIds))
                ..orderBy([(e) => OrderingTerm.asc(e.name)]))
              .get();

    final adherenceBlock = block ?? blocks.where((b) => b.isActive).firstOrNull;
    final planned = adherenceBlock == null
        ? <PlannedSession>[]
        : await (db.select(
            db.plannedSessions,
          )..where((p) => p.blockId.equals(adherenceBlock.id))).get();

    final aq = db.select(db.assessmentResults);
    if (adherenceBlock != null) {
      aq.where((a) => a.blockId.equals(adherenceBlock.id));
    }
    final assessments = await aq.get();

    return DashboardData(
      blocks: blocks,
      block: block,
      sessions: sessions,
      logs: logs,
      cardio: cardio,
      exercises: exercises,
      planned: planned,
      assessments: assessments,
    );
  }
}
