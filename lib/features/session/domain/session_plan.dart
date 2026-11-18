import 'dart:convert';

import '../../../core/enums.dart';

/// Um exercício dentro do plano congelado de uma sessão.
class PlanExercise {
  const PlanExercise({
    required this.exerciseId,
    required this.name,
    required this.logType,
    required this.isWarmup,
    required this.sets,
    this.repsText = '',
    this.repsMin,
    this.repsMax,
    this.rir = '',
    this.restSec = 0,
    this.tip = '',
  });

  final int exerciseId;
  final String name;
  final LogType logType;
  final bool isWarmup;
  final int sets;
  final String repsText;
  final int? repsMin;
  final int? repsMax;
  final String rir;
  final int restSec;
  final String tip;

  /// Tipo efetivo: aquecimento sempre só pede confirmação.
  LogType get effectiveLogType => isWarmup ? LogType.confirmOnly : logType;

  /// Valor alvo usado para pré-preencher reps/distância.
  int? get target => repsMax ?? repsMin;

  Map<String, dynamic> toJson() => {
    'exerciseId': exerciseId,
    'name': name,
    'logType': logType.name,
    'isWarmup': isWarmup,
    'sets': sets,
    'repsText': repsText,
    'repsMin': repsMin,
    'repsMax': repsMax,
    'rir': rir,
    'restSec': restSec,
    'tip': tip,
  };

  factory PlanExercise.fromJson(Map<String, dynamic> j) => PlanExercise(
    exerciseId: j['exerciseId'] as int,
    name: j['name'] as String,
    logType: LogType.values.byName(j['logType'] as String),
    isWarmup: j['isWarmup'] as bool,
    sets: j['sets'] as int,
    repsText: j['repsText'] as String? ?? '',
    repsMin: j['repsMin'] as int?,
    repsMax: j['repsMax'] as int?,
    rir: j['rir'] as String? ?? '',
    restSec: j['restSec'] as int? ?? 0,
    tip: j['tip'] as String? ?? '',
  );
}

/// Plano congelado no início da sessão (editar o bloco não altera sessões).
class SessionPlan {
  const SessionPlan(this.exercises);
  final List<PlanExercise> exercises;

  int get totalSets => exercises.fold(0, (s, e) => s + e.sets);

  String encode() => jsonEncode(exercises.map((e) => e.toJson()).toList());

  factory SessionPlan.decode(String json) => SessionPlan([
    for (final e in jsonDecode(json) as List)
      PlanExercise.fromJson(e as Map<String, dynamic>),
  ]);
}
