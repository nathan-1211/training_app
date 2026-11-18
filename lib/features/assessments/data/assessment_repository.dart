import 'package:drift/drift.dart';

import '../../../core/db/database.dart';

class AssessmentRepository {
  AssessmentRepository(this.db);
  final AppDatabase db;

  Future<void> saveAll({
    required int? blockId,
    required int? week,
    required DateTime date,
    required Map<String, double> values,
  }) {
    return db.transaction(() async {
      for (final e in values.entries) {
        await db
            .into(db.assessmentResults)
            .insert(
              AssessmentResultsCompanion.insert(
                blockId: Value(blockId),
                weekNumber: Value(week),
                date: date,
                testKey: e.key,
                value: e.value,
              ),
            );
      }
    });
  }

  Future<List<AssessmentResult>> ofBlock(int? blockId) {
    final q = db.select(db.assessmentResults)
      ..orderBy([(r) => OrderingTerm.asc(r.date)]);
    if (blockId != null) q.where((r) => r.blockId.equals(blockId));
    return q.get();
  }
}
