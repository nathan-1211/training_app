/// Pace em segundos por km, arredondado ao segundo.
/// Ex.: 3,2 km em 21:30 (1290 s) → 403 s = 6:43 min/km.
int? paceSecPerKm({required double km, required int durationSec}) {
  if (km <= 0 || durationSec <= 0) return null;
  return (durationSec / km).round();
}
