import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/db/database.dart';

/// Exporta/importa todo o banco em JSON.
class BackupService {
  BackupService(this.db);
  final AppDatabase db;

  static const format = 'treino-backup';
  static const version = 1;

  /// Ordem respeita as chaves estrangeiras (pais antes dos filhos).
  List<TableInfo<Table, dynamic>> get _tables => [
    db.exercises,
    db.blocks,
    db.blockWeeks,
    db.workoutTemplates,
    db.templateExercises,
    db.scheduleDays,
    db.plannedSessions,
    db.sessions,
    db.setLogs,
    db.cardioLogs,
    db.assessmentResults,
  ];

  Future<String> exportJson({DateTime? now}) async {
    final tables = <String, dynamic>{};
    for (final t in _tables) {
      final rows = await db.select(t).get();
      tables[t.actualTableName] = [
        for (final r in rows) (r as DataClass).toJson(),
      ];
    }
    return const JsonEncoder.withIndent(' ').convert({
      'format': format,
      'version': version,
      'schemaVersion': db.schemaVersion,
      'exportedAt': (now ?? DateTime.now()).toIso8601String(),
      'tables': tables,
    });
  }

  /// Substitui TODOS os dados pelo conteúdo do backup (numa transação:
  /// se algo falhar, nada muda).
  Future<void> importJson(String json) async {
    final data = jsonDecode(json);
    if (data is! Map || data['format'] != format) {
      throw const FormatException('Arquivo não é um backup do Treino');
    }
    final tables = data['tables'] as Map<String, dynamic>;
    await db.transaction(() async {
      for (final t in _tables.reversed) {
        await db.delete(t).go();
      }
      for (final t in _tables) {
        final rows = (tables[t.actualTableName] as List?) ?? const [];
        for (final r in rows) {
          final row = _fromJson(t, r as Map<String, dynamic>);
          await db.into(t).insert(row as Insertable);
        }
      }
    });
  }

  DataClass _fromJson(TableInfo t, Map<String, dynamic> j) {
    if (t == db.exercises) return Exercise.fromJson(j);
    if (t == db.blocks) return Block.fromJson(j);
    if (t == db.blockWeeks) return BlockWeek.fromJson(j);
    if (t == db.workoutTemplates) return WorkoutTemplate.fromJson(j);
    if (t == db.templateExercises) return TemplateExercise.fromJson(j);
    if (t == db.scheduleDays) return ScheduleDay.fromJson(j);
    if (t == db.plannedSessions) return PlannedSession.fromJson(j);
    if (t == db.sessions) return Session.fromJson(j);
    if (t == db.setLogs) return SetLog.fromJson(j);
    if (t == db.cardioLogs) return CardioLog.fromJson(j);
    if (t == db.assessmentResults) return AssessmentResult.fromJson(j);
    throw StateError('Tabela desconhecida: ${t.actualTableName}');
  }
}
