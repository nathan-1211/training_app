import '../../../core/db/database.dart';
import '../../dashboard/domain/strength_math.dart';
import 'session_plan.dart';

class PersonalRecord {
  const PersonalRecord({
    required this.exerciseName,
    required this.kind,
    required this.value,
    required this.previous,
  });
  final String exerciseName;

  /// 'carga' ou '1RM estimado'.
  final String kind;
  final double value;
  final double previous;
}

class SessionSummary {
  const SessionSummary({
    required this.templateName,
    required this.duration,
    required this.totalVolumeKg,
    required this.setCount,
    required this.records,
  });
  final String templateName;
  final Duration duration;
  final double totalVolumeKg;
  final int setCount;
  final List<PersonalRecord> records;
}

/// Volume = soma de carga × reps (só séries com carga e reps, sem aquecimento).
double volumeOf(Iterable<SetLog> logs) => logs
    .where((l) => !l.isWarmup && l.loadKg != null && l.reps != null)
    .fold(0.0, (s, l) => s + l.loadKg! * l.reps!);

/// [previousBest]: exerciseId → melhores marcas de sessões anteriores.
/// Só conta como recorde se superar uma marca anterior existente.
SessionSummary buildSummary({
  required Session session,
  required SessionPlan plan,
  required List<SetLog> logs,
  required Map<int, ({double load, double e1rm})> previousBest,
}) {
  final end = session.endedAt ?? DateTime.now();
  final records = <PersonalRecord>[];
  final names = {for (final e in plan.exercises) e.exerciseId: e.name};
  final byExercise = <int, List<SetLog>>{};
  for (final l in logs.where((l) => !l.isWarmup && l.loadKg != null)) {
    byExercise.putIfAbsent(l.exerciseId, () => []).add(l);
  }
  for (final entry in byExercise.entries) {
    final prev = previousBest[entry.key];
    if (prev == null) continue;
    final name = names[entry.key] ?? 'Exercício';
    final load = entry.value.fold(0.0, (m, l) => l.loadKg! > m ? l.loadKg! : m);
    if (prev.load > 0 && load > prev.load) {
      records.add(
        PersonalRecord(
          exerciseName: name,
          kind: 'carga',
          value: load,
          previous: prev.load,
        ),
      );
    }
    final sets = entry.value
        .where((l) => l.reps != null)
        .map((l) => LoadedSet(l.loadKg!, l.reps!));
    final e1 = bestE1RM(sets);
    if (prev.e1rm > 0 && e1 > prev.e1rm) {
      records.add(
        PersonalRecord(
          exerciseName: name,
          kind: '1RM estimado',
          value: e1,
          previous: prev.e1rm,
        ),
      );
    }
  }
  return SessionSummary(
    templateName: session.templateName,
    duration: end.difference(session.startedAt),
    totalVolumeKg: volumeOf(logs),
    setCount: logs.length,
    records: records,
  );
}
