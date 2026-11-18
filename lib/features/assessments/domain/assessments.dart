import '../../../core/db/database.dart';

class AssessmentDef {
  const AssessmentDef(this.key, this.label, this.unit, {this.decimal = false});
  final String key;
  final String label;
  final String unit;
  final bool decimal;
}

/// Testes das semanas 1 e 8.
const assessmentDefs = [
  AssessmentDef('knee_wall_right', 'Joelho-parede D', 'cm', decimal: true),
  AssessmentDef('knee_wall_left', 'Joelho-parede E', 'cm', decimal: true),
  AssessmentDef('pullups_max', 'Barras máximas', 'reps'),
  AssessmentDef('pushups_max', 'Flexões máximas', 'reps'),
  AssessmentDef(
    'trapbar_5rm_rir2',
    'Terra trap bar 5 reps (RIR 2)',
    'kg',
    decimal: true,
  ),
  AssessmentDef('distance_12min', "Distância em 12'", 'm'),
];

class AssessmentComparison {
  const AssessmentComparison(this.def, this.before, this.after);
  final AssessmentDef def;
  final double? before;
  final double? after;

  double? get diff => before == null || after == null ? null : after! - before!;
}

/// Último valor de cada teste por semana.
Map<String, double> latestByKey(Iterable<AssessmentResult> results) {
  final sorted = results.toList()..sort((a, b) => a.date.compareTo(b.date));
  return {for (final r in sorted) r.testKey: r.value};
}

/// Compara a semana [weekA] com a [weekB] (ex.: 1 vs 8).
List<AssessmentComparison> compareWeeks(
  List<AssessmentResult> results,
  int weekA,
  int weekB,
) {
  final a = latestByKey(results.where((r) => r.weekNumber == weekA));
  final b = latestByKey(results.where((r) => r.weekNumber == weekB));
  return [
    for (final d in assessmentDefs) AssessmentComparison(d, a[d.key], b[d.key]),
  ];
}
