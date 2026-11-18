import '../../../core/enums.dart';

/// Descrição pura (sem banco) de um bloco de periodização.
/// Usada pelo seed, pelo editor "Cadastrar bloco" e pela duplicação.
class BlockSpec {
  BlockSpec({
    required this.name,
    required this.startDate,
    required this.weeks,
    required this.workouts,
    required this.schedule,
    required this.weekSpecs,
  });

  String name;
  DateTime startDate;
  int weeks;
  List<WorkoutSpec> workouts;

  /// weekday (1 = segunda ... 7 = domingo, igual a [DateTime.weekday]) → dia.
  Map<int, DaySpec> schedule;

  /// Uma entrada por semana (1..weeks).
  List<WeekSpec> weekSpecs;

  DaySpec dayFor(int weekday) => schedule[weekday] ?? const DaySpec.rest();

  WeekSpec weekSpec(int week) => weekSpecs.firstWhere(
    (w) => w.week == week,
    orElse: () => WeekSpec(week: week),
  );

  /// Remove um treino e corrige a agenda (dias dele viram descanso).
  void removeWorkout(int index) {
    workouts.removeAt(index);
    schedule = {
      for (final e in schedule.entries)
        e.key: switch (e.value) {
          DaySpec(kind: DayKind.strength, workoutIndex: final i?)
              when i == index =>
            const DaySpec.rest(),
          DaySpec(kind: DayKind.strength, workoutIndex: final i?)
              when i > index =>
            DaySpec(kind: DayKind.strength, workoutIndex: i - 1),
          final d => d,
        },
    };
  }

  /// Garante que [weekSpecs] tenha exatamente [weeks] entradas.
  void normalizeWeeks() {
    final byWeek = {for (final w in weekSpecs) w.week: w};
    final last = weekSpecs.isEmpty ? null : weekSpecs.last;
    weekSpecs = [
      for (var i = 1; i <= weeks; i++)
        byWeek[i] ??
            WeekSpec(
              week: i,
              phase: last?.phase ?? '',
              mainSets: last?.mainSets ?? 3,
              rir: last?.rir ?? '',
              run: last?.run ?? '',
              conditioning: last?.conditioning ?? '',
            ),
    ];
  }
}

class WorkoutSpec {
  WorkoutSpec({required this.name, List<ExerciseSpec>? exercises})
    : exercises = exercises ?? [];

  String name;
  List<ExerciseSpec> exercises;
}

class ExerciseSpec {
  ExerciseSpec({
    required this.name,
    this.logType = LogType.loadReps,
    this.isWarmup = false,
    this.repsText = '',
    this.repsMin,
    this.repsMax,
    this.restSec = 90,
    this.tip = '',
    this.fixedSets,
  });

  String name;
  LogType logType;
  bool isWarmup;
  String repsText;
  int? repsMin;
  int? repsMax;
  int restSec;
  String tip;

  /// Séries fixas (independem da semana). Aquecimentos usam 2 por padrão.
  int? fixedSets;

  int setsForWeek(WeekSpec week) => fixedSets ?? (isWarmup ? 2 : week.mainSets);
}

class DaySpec {
  const DaySpec({required this.kind, this.workoutIndex});
  const DaySpec.rest() : kind = DayKind.rest, workoutIndex = null;

  final DayKind kind;

  /// Índice em [BlockSpec.workouts] quando [kind] é força.
  final int? workoutIndex;
}

class WeekSpec {
  WeekSpec({
    required this.week,
    this.phase = '',
    this.mainSets = 3,
    this.rir = '',
    this.run = '',
    this.conditioning = '',
  });

  int week;
  String phase;
  int mainSets;
  String rir;
  String run;
  String conditioning;
}

/// Extrai `repsMin`/`repsMax` de textos como "6–8", "10/lado", "30–40 m", "12".
({int? min, int? max}) parseRepsRange(String text) {
  final numbers = RegExp(r'\d+')
      .allMatches(text)
      .map((m) => int.parse(m.group(0)!))
      .toList();
  if (numbers.isEmpty) return (min: null, max: null);
  final hasRange = RegExp(r'\d+\s*[–\-]\s*\d+').hasMatch(text);
  if (hasRange && numbers.length >= 2) {
    return (min: numbers[0], max: numbers[1]);
  }
  return (min: numbers[0], max: numbers[0]);
}
