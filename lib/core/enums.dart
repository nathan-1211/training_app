/// Enums persistidos no banco (por nome, via `textEnum`).
/// Não renomeie valores sem uma migration.
library;

/// Como uma série de um exercício é registrada.
enum LogType {
  loadReps,
  loadDistance,
  repsOnly,
  timeOnly,
  confirmOnly;

  String get label => switch (this) {
    LogType.loadReps => 'Carga + reps',
    LogType.loadDistance => 'Carga + distância',
    LogType.repsOnly => 'Só reps',
    LogType.timeOnly => 'Só tempo',
    LogType.confirmOnly => 'Só confirmar',
  };

  bool get hasLoad => this == LogType.loadReps || this == LogType.loadDistance;
}

/// O que acontece em um dia da agenda do bloco.
enum DayKind {
  strength,
  run,
  conditioning,
  rest;

  String get label => switch (this) {
    DayKind.strength => 'Força',
    DayKind.run => 'Corrida',
    DayKind.conditioning => 'Condicionamento',
    DayKind.rest => 'Descanso',
  };
}

enum SessionStatus { active, finished, abandoned }

enum CardioType {
  run,
  emom,
  cross;

  String get label => switch (this) {
    CardioType.run => 'Corrida',
    CardioType.emom => 'EMOM',
    CardioType.cross => 'Cross',
  };

  bool get isConditioning => this != CardioType.run;
}
