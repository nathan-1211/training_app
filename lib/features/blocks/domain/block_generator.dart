import '../../../core/enums.dart';
import 'block_spec.dart';

/// Sessão planejada gerada a partir de um bloco (semana × dia).
class PlannedSessionDraft {
  const PlannedSessionDraft({
    required this.week,
    required this.date,
    required this.kind,
    this.workoutIndex,
  });

  final int week;
  final DateTime date;
  final DayKind kind;
  final int? workoutIndex;

  @override
  String toString() =>
      'PlannedSessionDraft(w$week, ${date.toIso8601String()}, $kind, $workoutIndex)';
}

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Gera todas as sessões planejadas (sem dias de descanso).
/// A semana 1 começa na data de início; cada semana tem 7 dias corridos.
List<PlannedSessionDraft> generatePlannedSessions(BlockSpec spec) {
  final start = dateOnly(spec.startDate);
  final result = <PlannedSessionDraft>[];
  for (var week = 1; week <= spec.weeks; week++) {
    for (var day = 0; day < 7; day++) {
      // Construção por componentes evita erros de horário de verão.
      final date = DateTime(
        start.year,
        start.month,
        start.day + (week - 1) * 7 + day,
      );
      final daySpec = spec.dayFor(date.weekday);
      if (daySpec.kind == DayKind.rest) continue;
      if (daySpec.kind == DayKind.strength &&
          (daySpec.workoutIndex == null ||
              daySpec.workoutIndex! >= spec.workouts.length)) {
        continue;
      }
      result.add(
        PlannedSessionDraft(
          week: week,
          date: date,
          kind: daySpec.kind,
          workoutIndex: daySpec.kind == DayKind.strength
              ? daySpec.workoutIndex
              : null,
        ),
      );
    }
  }
  return result;
}

/// Semana do bloco (1-based) para [date], ou null se fora do bloco.
int? blockWeekFor({
  required DateTime startDate,
  required int weeks,
  required DateTime date,
}) {
  final start = dateOnly(startDate);
  final d = dateOnly(date);
  // Diferença em dias pelo calendário (UTC evita horário de verão).
  final days = DateTime.utc(
    d.year,
    d.month,
    d.day,
  ).difference(DateTime.utc(start.year, start.month, start.day)).inDays;
  if (days < 0) return null;
  final week = days ~/ 7 + 1;
  return week > weeks ? null : week;
}

/// Segunda-feira da semana de [d].
DateTime mondayOf(DateTime d) =>
    DateTime(d.year, d.month, d.day - (d.weekday - 1));
