import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../../../core/enums.dart';
import '../../blocks/data/block_repository.dart';
import '../../blocks/domain/block_generator.dart';
import '../domain/pace.dart';

class CardioRepository {
  CardioRepository(this.db);
  final AppDatabase db;

  Future<int> save({
    required CardioType type,
    required DateTime date,
    required int durationSec,
    double? km,
    int? rpe,
    String? notes,
  }) async {
    final block = await BlockRepository(db).activeBlock();
    final week = block == null
        ? null
        : blockWeekFor(
            startDate: block.startDate,
            weeks: block.weeks,
            date: date,
          );
    return db
        .into(db.cardioLogs)
        .insert(
          CardioLogsCompanion.insert(
            type: type,
            date: date,
            durationSec: durationSec,
            km: Value(km),
            paceSecPerKm: Value(
              km == null
                  ? null
                  : paceSecPerKm(km: km, durationSec: durationSec),
            ),
            rpe: Value(rpe),
            notes: Value(
              notes == null || notes.trim().isEmpty ? null : notes.trim(),
            ),
            blockId: Value(week == null ? null : block!.id),
            weekNumber: Value(week),
          ),
        );
  }

  Future<List<CardioLog>> recent({int limit = 10}) =>
      (db.select(db.cardioLogs)
            ..orderBy([(c) => OrderingTerm.desc(c.date)])
            ..limit(limit))
          .get();

  Future<void> delete(int id) =>
      (db.delete(db.cardioLogs)..where((c) => c.id.equals(id))).go();
}
