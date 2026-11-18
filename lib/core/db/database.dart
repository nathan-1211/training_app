import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../features/blocks/data/block_repository.dart';
import '../../features/blocks/domain/seed_block1.dart';
import '../enums.dart';
import 'tables.dart';

export 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Exercises,
    Blocks,
    BlockWeeks,
    WorkoutTemplates,
    TemplateExercises,
    ScheduleDays,
    PlannedSessions,
    Sessions,
    SetLogs,
    CardioLogs,
    AssessmentResults,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor, {this.seedOnCreate = true, this.now});

  /// Banco do app no diretório de documentos do iOS.
  factory AppDatabase.open() => AppDatabase(driftDatabase(name: 'treino'));

  /// Faz o seed do Bloco 1 quando o banco é criado.
  final bool seedOnCreate;

  /// Relógio injetável para o seed (testes).
  final DateTime Function()? now;

  /// Versão do schema. Ao mudar tabelas: incremente e adicione um passo em
  /// [migration] (`onUpgrade`). Nunca altere um passo já publicado.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Migrations versionadas entram aqui, ex.:
      // if (from < 2) { await m.addColumn(sessions, sessions.algumaColuna); }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated && seedOnCreate) {
        final repo = BlockRepository(this);
        await repo.createFromSpec(seedBlock1(now: now?.call()), activate: true);
      }
    },
  );
}
