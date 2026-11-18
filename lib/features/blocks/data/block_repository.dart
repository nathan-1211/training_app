import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/enums.dart';
import '../domain/block_generator.dart';
import '../domain/block_spec.dart';

/// O que está planejado para um dia, já resolvido (para a tela inicial).
class DayPlan {
  const DayPlan({
    required this.block,
    required this.date,
    required this.week,
    required this.kind,
    this.template,
    this.weekRow,
  });

  final Block block;
  final DateTime date;

  /// null quando a data está fora do bloco.
  final int? week;
  final DayKind kind;
  final WorkoutTemplate? template;
  final BlockWeek? weekRow;
}

class BlockRepository {
  BlockRepository(this.db);
  final AppDatabase db;

  Future<int> _exerciseId(String name) async {
    final trimmed = name.trim();
    final existing = await (db.select(
      db.exercises,
    )..where((e) => e.name.equals(trimmed))).getSingleOrNull();
    if (existing != null) return existing.id;
    return db
        .into(db.exercises)
        .insert(ExercisesCompanion.insert(name: trimmed));
  }

  /// Cria o bloco e gera todas as sessões planejadas.
  Future<int> createFromSpec(BlockSpec spec, {bool activate = true}) {
    return db.transaction(() async {
      final blockId = await db
          .into(db.blocks)
          .insert(
            BlocksCompanion.insert(
              name: spec.name.trim(),
              startDate: dateOnly(spec.startDate),
              weeks: spec.weeks,
            ),
          );
      await _writeContents(blockId, spec);
      if (activate) await setActive(blockId);
      return blockId;
    });
  }

  /// Substitui o conteúdo do bloco (treinos, agenda, semanas) e regenera
  /// as sessões planejadas. O histórico (sessões feitas) não é afetado.
  Future<void> updateFromSpec(int blockId, BlockSpec spec) {
    return db.transaction(() async {
      await (db.update(db.blocks)..where((b) => b.id.equals(blockId))).write(
        BlocksCompanion(
          name: Value(spec.name.trim()),
          startDate: Value(dateOnly(spec.startDate)),
          weeks: Value(spec.weeks),
        ),
      );
      await _deleteContents(blockId);
      await _writeContents(blockId, spec);
    });
  }

  Future<void> _deleteContents(int blockId) async {
    final templateIds = await (db.select(
      db.workoutTemplates,
    )..where((t) => t.blockId.equals(blockId))).map((t) => t.id).get();
    await (db.delete(
      db.templateExercises,
    )..where((t) => t.templateId.isIn(templateIds))).go();
    await (db.delete(
      db.plannedSessions,
    )..where((p) => p.blockId.equals(blockId))).go();
    await (db.delete(
      db.scheduleDays,
    )..where((s) => s.blockId.equals(blockId))).go();
    await (db.delete(
      db.blockWeeks,
    )..where((w) => w.blockId.equals(blockId))).go();
    await (db.delete(
      db.workoutTemplates,
    )..where((t) => t.blockId.equals(blockId))).go();
  }

  Future<void> _writeContents(int blockId, BlockSpec spec) async {
    spec.normalizeWeeks();
    final templateIds = <int>[];
    for (var i = 0; i < spec.workouts.length; i++) {
      final w = spec.workouts[i];
      final tId = await db
          .into(db.workoutTemplates)
          .insert(
            WorkoutTemplatesCompanion.insert(
              blockId: blockId,
              name: w.name.trim(),
              sortOrder: i,
            ),
          );
      templateIds.add(tId);
      for (var p = 0; p < w.exercises.length; p++) {
        final e = w.exercises[p];
        await db
            .into(db.templateExercises)
            .insert(
              TemplateExercisesCompanion.insert(
                templateId: tId,
                exerciseId: await _exerciseId(e.name),
                position: p,
                logType: e.logType,
                isWarmup: Value(e.isWarmup),
                repsText: Value(e.repsText),
                repsMin: Value(e.repsMin),
                repsMax: Value(e.repsMax),
                restSec: Value(e.restSec),
                tip: Value(e.tip),
                fixedSets: Value(e.fixedSets),
              ),
            );
      }
    }
    for (final w in spec.weekSpecs) {
      await db
          .into(db.blockWeeks)
          .insert(
            BlockWeeksCompanion.insert(
              blockId: blockId,
              weekNumber: w.week,
              phase: Value(w.phase),
              mainSets: w.mainSets,
              rir: Value(w.rir),
              runPrescription: Value(w.run),
              conditioningPrescription: Value(w.conditioning),
            ),
          );
    }
    for (var weekday = 1; weekday <= 7; weekday++) {
      final d = spec.dayFor(weekday);
      await db
          .into(db.scheduleDays)
          .insert(
            ScheduleDaysCompanion.insert(
              blockId: blockId,
              weekday: weekday,
              kind: d.kind,
              templateId: Value(
                d.workoutIndex == null || d.workoutIndex! >= templateIds.length
                    ? null
                    : templateIds[d.workoutIndex!],
              ),
            ),
          );
    }
    for (final p in generatePlannedSessions(spec)) {
      await db
          .into(db.plannedSessions)
          .insert(
            PlannedSessionsCompanion.insert(
              blockId: blockId,
              weekNumber: p.week,
              date: p.date,
              kind: p.kind,
              templateId: Value(
                p.workoutIndex == null ? null : templateIds[p.workoutIndex!],
              ),
            ),
          );
    }
  }

  /// Reconstrói o [BlockSpec] a partir do banco (para editar ou duplicar).
  Future<BlockSpec> loadSpec(int blockId) async {
    final block = await (db.select(
      db.blocks,
    )..where((b) => b.id.equals(blockId))).getSingle();
    final templates = await templatesOf(blockId);
    final workouts = <WorkoutSpec>[];
    for (final t in templates) {
      final rows = await templateExercises(t.id);
      workouts.add(
        WorkoutSpec(
          name: t.name,
          exercises: [
            for (final r in rows)
              ExerciseSpec(
                name: r.exercise.name,
                logType: r.te.logType,
                isWarmup: r.te.isWarmup,
                repsText: r.te.repsText,
                repsMin: r.te.repsMin,
                repsMax: r.te.repsMax,
                restSec: r.te.restSec,
                tip: r.te.tip,
                fixedSets: r.te.fixedSets,
              ),
          ],
        ),
      );
    }
    final days = await (db.select(
      db.scheduleDays,
    )..where((s) => s.blockId.equals(blockId))).get();
    final schedule = <int, DaySpec>{};
    for (final d in days) {
      final idx = d.templateId == null
          ? null
          : templates.indexWhere((t) => t.id == d.templateId);
      schedule[d.weekday] = DaySpec(
        kind: d.kind,
        workoutIndex: (idx == null || idx < 0) ? null : idx,
      );
    }
    final weeks = await weeksOf(blockId);
    return BlockSpec(
      name: block.name,
      startDate: block.startDate,
      weeks: block.weeks,
      workouts: workouts,
      schedule: schedule,
      weekSpecs: [
        for (final w in weeks)
          WeekSpec(
            week: w.weekNumber,
            phase: w.phase,
            mainSets: w.mainSets,
            rir: w.rir,
            run: w.runPrescription,
            conditioning: w.conditioningPrescription,
          ),
      ],
    );
  }

  Future<int> duplicate(
    int blockId, {
    String? name,
    DateTime? startDate,
  }) async {
    final spec = await loadSpec(blockId);
    final block = await (db.select(
      db.blocks,
    )..where((b) => b.id.equals(blockId))).getSingle();
    spec.name = name ?? _nextName(spec.name);
    spec.startDate =
        startDate ??
        DateTime(
          block.startDate.year,
          block.startDate.month,
          block.startDate.day + block.weeks * 7,
        );
    return createFromSpec(spec, activate: false);
  }

  String _nextName(String name) {
    final m = RegExp(r'^(.*?)(\d+)\s*$').firstMatch(name);
    if (m == null) return '$name (cópia)';
    return '${m.group(1)}${int.parse(m.group(2)!) + 1}';
  }

  Future<void> setActive(int blockId) async {
    await db
        .update(db.blocks)
        .write(const BlocksCompanion(isActive: Value(false)));
    await (db.update(db.blocks)..where((b) => b.id.equals(blockId))).write(
      const BlocksCompanion(isActive: Value(true)),
    );
  }

  Future<List<Block>> allBlocks() => (db.select(
    db.blocks,
  )..orderBy([(b) => OrderingTerm.desc(b.startDate)])).get();

  Future<Block?> activeBlock() => (db.select(
    db.blocks,
  )..where((b) => b.isActive.equals(true))).getSingleOrNull();

  Future<List<WorkoutTemplate>> templatesOf(int blockId) =>
      (db.select(db.workoutTemplates)
            ..where((t) => t.blockId.equals(blockId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Future<List<BlockWeek>> weeksOf(int blockId) =>
      (db.select(db.blockWeeks)
            ..where((w) => w.blockId.equals(blockId))
            ..orderBy([(w) => OrderingTerm.asc(w.weekNumber)]))
          .get();

  Future<BlockWeek?> weekRow(int blockId, int week) =>
      (db.select(db.blockWeeks)..where(
            (w) => w.blockId.equals(blockId) & w.weekNumber.equals(week),
          ))
          .getSingleOrNull();

  Future<List<({TemplateExercise te, Exercise exercise})>> templateExercises(
    int templateId,
  ) async {
    final q =
        db.select(db.templateExercises).join([
            innerJoin(
              db.exercises,
              db.exercises.id.equalsExp(db.templateExercises.exerciseId),
            ),
          ])
          ..where(db.templateExercises.templateId.equals(templateId))
          ..orderBy([OrderingTerm.asc(db.templateExercises.position)]);
    final rows = await q.get();
    return [
      for (final r in rows)
        (
          te: r.readTable(db.templateExercises),
          exercise: r.readTable(db.exercises),
        ),
    ];
  }

  Future<List<PlannedSession>> plannedOf(int blockId) =>
      (db.select(db.plannedSessions)
            ..where((p) => p.blockId.equals(blockId))
            ..orderBy([(p) => OrderingTerm.asc(p.date)]))
          .get();

  /// Plano do dia [date] no bloco ativo, ou null se não há bloco ativo.
  Future<DayPlan?> dayPlan(DateTime date) async {
    final block = await activeBlock();
    if (block == null) return null;
    final day = dateOnly(date);
    final week = blockWeekFor(
      startDate: block.startDate,
      weeks: block.weeks,
      date: day,
    );
    if (week == null) {
      return DayPlan(block: block, date: day, week: null, kind: DayKind.rest);
    }
    final planned =
        await (db.select(db.plannedSessions)..where(
              (p) =>
                  p.blockId.equals(block.id) &
                  p.date.isBetweenValues(
                    day,
                    DateTime(day.year, day.month, day.day, 23, 59, 59),
                  ),
            ))
            .get();
    final weekRow = await this.weekRow(block.id, week);
    if (planned.isEmpty) {
      return DayPlan(
        block: block,
        date: day,
        week: week,
        kind: DayKind.rest,
        weekRow: weekRow,
      );
    }
    // Prioriza força se houver mais de um planejamento no dia.
    planned.sort((a, b) => a.kind.index.compareTo(b.kind.index));
    final p = planned.first;
    WorkoutTemplate? template;
    if (p.templateId != null) {
      template = await (db.select(
        db.workoutTemplates,
      )..where((t) => t.id.equals(p.templateId!))).getSingleOrNull();
    }
    return DayPlan(
      block: block,
      date: day,
      week: week,
      kind: p.kind,
      template: template,
      weekRow: weekRow,
    );
  }
}
