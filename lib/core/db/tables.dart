import 'package:drift/drift.dart';

import '../enums.dart';

/// Exercício global (por nome) — liga o histórico entre blocos.
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
}

class Blocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get startDate => dateTime()();
  IntColumn get weeks => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Prescrição por semana do bloco.
class BlockWeeks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(Blocks, #id)();
  IntColumn get weekNumber => integer()();
  TextColumn get phase => text().withDefault(const Constant(''))();
  IntColumn get mainSets => integer()();
  TextColumn get rir => text().withDefault(const Constant(''))();
  TextColumn get runPrescription => text().withDefault(const Constant(''))();
  TextColumn get conditioningPrescription =>
      text().withDefault(const Constant(''))();
}

class WorkoutTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(Blocks, #id)();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer()();
}

class TemplateExercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateId => integer().references(WorkoutTemplates, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get position => integer()();
  TextColumn get logType => textEnum<LogType>()();
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  TextColumn get repsText => text().withDefault(const Constant(''))();
  IntColumn get repsMin => integer().nullable()();
  IntColumn get repsMax => integer().nullable()();
  IntColumn get restSec => integer().withDefault(const Constant(0))();
  TextColumn get tip => text().withDefault(const Constant(''))();
  IntColumn get fixedSets => integer().nullable()();
}

/// Agenda semanal do bloco: weekday 1..7 (seg..dom).
class ScheduleDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(Blocks, #id)();
  IntColumn get weekday => integer()();
  TextColumn get kind => textEnum<DayKind>()();
  IntColumn get templateId => integer().nullable()();
}

class PlannedSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().references(Blocks, #id)();
  IntColumn get weekNumber => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get kind => textEnum<DayKind>()();
  IntColumn get templateId => integer().nullable()();
}

/// Sessão de força. O cursor e o horário da última série são persistidos
/// a cada mudança — nada de estado importante só em memória.
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().nullable()();
  IntColumn get templateId => integer().nullable()();
  TextColumn get templateName => text()();
  IntColumn get weekNumber => integer().nullable()();

  /// Snapshot JSON do plano (exercícios × séries) no momento do início.
  TextColumn get planJson => text()();
  TextColumn get status => textEnum<SessionStatus>()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get cursorExercise => integer().withDefault(const Constant(0))();
  IntColumn get cursorSet => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSetAt => dateTime().nullable()();
  DateTimeColumn get restEndsAt => dateTime().nullable()();
}

class SetLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get exerciseId => integer()();

  /// Posição do exercício no plano da sessão.
  IntColumn get exerciseIndex => integer()();
  IntColumn get setIndex => integer()();
  RealColumn get loadKg => real().nullable()();
  IntColumn get reps => integer().nullable()();
  RealColumn get distanceM => real().nullable()();
  IntColumn get durationSec => integer().nullable()();
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

class CardioLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => textEnum<CardioType>()();
  DateTimeColumn get date => dateTime()();
  RealColumn get km => real().nullable()();
  IntColumn get durationSec => integer()();
  IntColumn get paceSecPerKm => integer().nullable()();
  IntColumn get rpe => integer().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get blockId => integer().nullable()();
  IntColumn get weekNumber => integer().nullable()();
}

/// Resultado de teste físico (semanas 1 e 8).
class AssessmentResults extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get blockId => integer().nullable()();
  IntColumn get weekNumber => integer().nullable()();
  DateTimeColumn get date => dateTime()();
  TextColumn get testKey => text()();
  RealColumn get value => real()();
}
