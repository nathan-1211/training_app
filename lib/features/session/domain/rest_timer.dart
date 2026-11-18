/// Timer de descanso calculado por timestamp — nada roda em segundo plano.
/// O fim do descanso é `horário da última série + descanso prescrito`.
class RestTimer {
  const RestTimer._();

  static DateTime? endsAt(DateTime? lastSetAt, int restSec) {
    if (lastSetAt == null || restSec <= 0) return null;
    return lastSetAt.add(Duration(seconds: restSec));
  }

  /// Tempo restante (nunca negativo). Duration.zero se não há descanso.
  static Duration remaining(DateTime? restEndsAt, DateTime now) {
    if (restEndsAt == null) return Duration.zero;
    final d = restEndsAt.difference(now);
    return d.isNegative ? Duration.zero : d;
  }

  static bool isResting(DateTime? restEndsAt, DateTime now) =>
      remaining(restEndsAt, now) > Duration.zero;
}
