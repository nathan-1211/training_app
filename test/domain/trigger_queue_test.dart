import 'package:flutter_test/flutter_test.dart';
import 'package:training/features/trigger/domain/trigger_queue.dart';

void main() {
  final t0 = DateTime(2026, 11, 16, 10);
  const uri = 'treino://registrar';

  TriggerEvent link(TriggerSource s, [Duration offset = Duration.zero]) =>
      TriggerEvent(source: s, uri: uri, receivedAt: t0.add(offset));

  test(
    'antes de pronto, enfileira; ao ficar pronto processa uma vez',
    () async {
      var processed = 0;
      final q = TriggerQueue(onProcess: (_) async => processed++);
      expect(q.enqueue(link(TriggerSource.initialLink)), isTrue);
      expect(processed, 0);
      expect(q.hasPending, isTrue);
      await q.markReady();
      expect(processed, 1);
      expect(q.hasPending, isFalse);
    },
  );

  test('link inicial + mesmo link no stream = um gatilho só', () async {
    var processed = 0;
    final q = TriggerQueue(onProcess: (_) async => processed++);
    q.enqueue(link(TriggerSource.initialLink));
    final dup = q.enqueue(
      link(TriggerSource.linkStream, const Duration(milliseconds: 200)),
    );
    expect(dup, isFalse);
    await q.markReady();
    expect(processed, 1);
  });

  test(
    'ordem inversa (stream antes do inicial) também é deduplicada',
    () async {
      var processed = 0;
      final q = TriggerQueue(onProcess: (_) async => processed++);
      await q.markReady();
      q.enqueue(link(TriggerSource.linkStream));
      q.enqueue(
        link(TriggerSource.initialLink, const Duration(milliseconds: 50)),
      );
      await q.idle;
      expect(processed, 1);
    },
  );

  test('dois toques duplos reais pelo stream são processados', () async {
    var processed = 0;
    final q = TriggerQueue(onProcess: (_) async => processed++);
    await q.markReady();
    q.enqueue(link(TriggerSource.linkStream));
    q.enqueue(link(TriggerSource.linkStream, const Duration(seconds: 40)));
    await q.idle;
    expect(processed, 2);
  });

  test('App Intent com o mesmo id nunca é processado duas vezes', () async {
    var processed = 0;
    final q = TriggerQueue(onProcess: (_) async => processed++);
    await q.markReady();
    TriggerEvent intent(String id) =>
        TriggerEvent(source: TriggerSource.appIntent, id: id, receivedAt: t0);
    q.enqueue(intent('a'));
    q.enqueue(intent('a'));
    q.enqueue(intent('b'));
    await q.idle;
    expect(processed, 2);
  });

  test(
    'vários gatilhos acumulados no cold start viram um processamento',
    () async {
      var processed = 0;
      final q = TriggerQueue(onProcess: (_) async => processed++);
      q.enqueue(
        TriggerEvent(source: TriggerSource.appIntent, id: 'x', receivedAt: t0),
      );
      q.enqueue(link(TriggerSource.initialLink));
      await q.markReady();
      await q.markReady(); // idempotente
      expect(processed, 1);
    },
  );

  test('processamento é serial e um erro não trava a fila', () async {
    final order = <int>[];
    var n = 0;
    final q = TriggerQueue(
      onProcess: (_) async {
        final me = ++n;
        if (me == 1) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
          order.add(me);
          throw StateError('falhou');
        }
        order.add(me);
      },
    );
    await q.markReady();
    q.enqueue(link(TriggerSource.linkStream));
    q.enqueue(link(TriggerSource.linkStream, const Duration(seconds: 10)));
    await q.idle;
    expect(order, [1, 2]);
  });
}
