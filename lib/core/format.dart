/// Formatação pt-BR: dd/mm/aaaa, vírgula decimal, mm:ss.
library;

String two(int n) => n.toString().padLeft(2, '0');

String formatDate(DateTime d) => '${two(d.day)}/${two(d.month)}/${d.year}';

String formatShortDate(DateTime d) => '${two(d.day)}/${two(d.month)}';

const weekdayNames = {
  1: 'Segunda',
  2: 'Terça',
  3: 'Quarta',
  4: 'Quinta',
  5: 'Sexta',
  6: 'Sábado',
  7: 'Domingo',
};

/// 42.5 → "42,5"; 40.0 → "40".
String formatNumber(num? v, {int maxDecimals = 1}) {
  if (v == null) return '–';
  if (v == v.roundToDouble()) return v.round().toString();
  var s = v.toStringAsFixed(maxDecimals);
  if (s.contains('.')) {
    s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
  return s.replaceAll('.', ',');
}

/// Aceita vírgula ou ponto decimal. Retorna null se vazio/inválido.
double? parseDecimal(String text) {
  final t = text.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  return double.tryParse(t);
}

int? parseIntOrNull(String text) => int.tryParse(text.trim());

/// Segundos → "m:ss" ou "h:mm:ss".
String formatDuration(int totalSec) {
  final neg = totalSec < 0;
  final s = totalSec.abs();
  final h = s ~/ 3600;
  final m = (s % 3600) ~/ 60;
  final sec = s % 60;
  final body = h > 0 ? '$h:${two(m)}:${two(sec)}' : '$m:${two(sec)}';
  return neg ? '-$body' : body;
}

/// "mm:ss", "h:mm:ss" ou só minutos ("25") → segundos. null se inválido.
int? parseDuration(String text) {
  final t = text.trim();
  if (t.isEmpty) return null;
  final parts = t.split(':');
  if (parts.length > 3) return null;
  final nums = parts.map((p) => int.tryParse(p.trim())).toList();
  if (nums.any((n) => n == null || n < 0)) return null;
  if (nums.length == 1) return nums[0]! * 60;
  if (nums.length == 2) {
    if (nums[1]! >= 60) return null;
    return nums[0]! * 60 + nums[1]!;
  }
  if (nums[1]! >= 60 || nums[2]! >= 60) return null;
  return nums[0]! * 3600 + nums[1]! * 60 + nums[2]!;
}

/// Pace em s/km → "6:43 min/km".
String formatPace(int? secPerKm) =>
    secPerKm == null ? '–' : '${formatDuration(secPerKm)} min/km';
