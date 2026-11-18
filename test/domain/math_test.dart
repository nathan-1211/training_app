import 'package:flutter_test/flutter_test.dart';
import 'package:training/core/format.dart';
import 'package:training/features/cardio/domain/pace.dart';
import 'package:training/features/dashboard/domain/strength_math.dart';
import 'package:training/features/session/domain/rest_timer.dart';

void main() {
  group('pace', () {
    test('3,2 km em 21:30 = 6:43 min/km', () {
      final secs = parseDuration('21:30')!;
      expect(secs, 1290);
      final pace = paceSecPerKm(km: parseDecimal('3,2')!, durationSec: secs);
      expect(pace, 403);
      expect(formatPace(pace), '6:43 min/km');
    });

    test('h:mm:ss e entradas inválidas', () {
      expect(parseDuration('1:05:00'), 3900);
      expect(parseDuration('25'), 1500);
      expect(parseDuration('5:75'), isNull);
      expect(parseDuration('abc'), isNull);
      expect(paceSecPerKm(km: 0, durationSec: 100), isNull);
    });
  });

  group('Epley', () {
    test('carga × (1 + reps/30)', () {
      expect(epley1RM(100, 10), closeTo(133.333, 0.001));
      expect(epley1RM(60, 5), closeTo(70, 0.0001));
      expect(epley1RM(0, 5), 0);
    });

    test('melhor série da sessão', () {
      const sets = [LoadedSet(100, 5), LoadedSet(90, 10), LoadedSet(105, 2)];
      expect(bestE1RM(sets), closeTo(120, 0.0001)); // 90×10
      expect(bestLoad(sets), 105);
    });
  });

  group('descanso por timestamp', () {
    final last = DateTime(2026, 11, 16, 10, 0, 0);

    test('fim = última série + descanso', () {
      expect(RestTimer.endsAt(last, 150), DateTime(2026, 11, 16, 10, 2, 30));
      expect(RestTimer.endsAt(last, 0), isNull);
      expect(RestTimer.endsAt(null, 90), isNull);
    });

    test('restante calculado pelo relógio, mesmo após o app dormir', () {
      final end = RestTimer.endsAt(last, 150)!;
      expect(RestTimer.remaining(end, last), const Duration(seconds: 150));
      // Tela apagou 1 min e 40 s depois:
      expect(
        RestTimer.remaining(end, last.add(const Duration(seconds: 100))),
        const Duration(seconds: 50),
      );
      // Voltou depois de 2 min: descanso já acabou, nunca negativo.
      expect(
        RestTimer.remaining(
          end,
          last.add(const Duration(minutes: 2, seconds: 31)),
        ),
        Duration.zero,
      );
      expect(
        RestTimer.isResting(end, last.add(const Duration(minutes: 5))),
        isFalse,
      );
    });
  });

  group('formatação pt-BR', () {
    test('números e datas', () {
      expect(formatNumber(42.5), '42,5');
      expect(formatNumber(40.0), '40');
      expect(parseDecimal('22,5'), 22.5);
      expect(formatDate(DateTime(2026, 3, 7)), '07/03/2026');
      expect(formatDuration(3725), '1:02:05');
    });
  });
}
