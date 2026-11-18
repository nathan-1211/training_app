/// 1RM estimado por Epley: carga × (1 + reps/30).
double epley1RM(double loadKg, int reps) {
  if (loadKg <= 0 || reps <= 0) return 0;
  return loadKg * (1 + reps / 30);
}

/// Uma série com carga e reps.
class LoadedSet {
  const LoadedSet(this.loadKg, this.reps);
  final double loadKg;
  final int reps;

  double get e1rm => epley1RM(loadKg, reps);
  double get volume => loadKg * reps;
}

/// Melhor 1RM estimado de um conjunto de séries (0 se vazio).
double bestE1RM(Iterable<LoadedSet> sets) =>
    sets.fold(0.0, (best, s) => s.e1rm > best ? s.e1rm : best);

double bestLoad(Iterable<LoadedSet> sets) =>
    sets.fold(0.0, (best, s) => s.loadKg > best ? s.loadKg : best);
