import 'package:flutter_test/flutter_test.dart';
import 'package:training/core/enums.dart';
import 'package:training/features/session/domain/session_cursor.dart';
import 'package:training/features/session/domain/session_plan.dart';

PlanExercise ex(int id, int sets, {bool warmup = false}) => PlanExercise(
  exerciseId: id,
  name: 'Ex $id',
  logType: warmup ? LogType.confirmOnly : LogType.loadReps,
  isWarmup: warmup,
  sets: sets,
);

void main() {
  final plan = SessionPlan([ex(1, 2, warmup: true), ex(2, 3), ex(3, 1)]);

  test('avança para a próxima série do mesmo exercício', () {
    expect(
      CursorLogic.advance(plan, const SessionCursor(1, 0)),
      const SessionCursor(1, 1),
    );
    expect(
      CursorLogic.advance(plan, const SessionCursor(1, 1)),
      const SessionCursor(1, 2),
    );
  });

  test('completou o exercício → próximo exercício, série 1', () {
    expect(
      CursorLogic.advance(plan, const SessionCursor(0, 1)),
      const SessionCursor(1, 0),
    );
    expect(
      CursorLogic.advance(plan, const SessionCursor(1, 2)),
      const SessionCursor(2, 0),
    );
  });

  test('última série do último exercício → fim (null)', () {
    expect(CursorLogic.advance(plan, const SessionCursor(2, 0)), isNull);
  });

  test('percorrer o plano inteiro dá exatamente totalSets passos', () {
    SessionCursor? c = SessionCursor.start;
    var steps = 0;
    while (c != null) {
      steps++;
      c = CursorLogic.advance(plan, c);
    }
    expect(steps, plan.totalSets);
    expect(steps, 6);
  });

  test('exercício com 0 séries é pulado', () {
    final p = SessionPlan([ex(1, 1), ex(2, 0), ex(3, 1)]);
    expect(
      CursorLogic.advance(p, SessionCursor.start),
      const SessionCursor(2, 0),
    );
  });

  test('pular exercício vai para o próximo; no último, termina', () {
    expect(
      CursorLogic.skipExercise(plan, const SessionCursor(1, 1)),
      const SessionCursor(2, 0),
    );
    expect(CursorLogic.skipExercise(plan, const SessionCursor(2, 0)), isNull);
  });

  test('plano sobrevive a encode/decode (snapshot no banco)', () {
    final decoded = SessionPlan.decode(plan.encode());
    expect(decoded.exercises.length, 3);
    expect(decoded.exercises[0].isWarmup, isTrue);
    expect(decoded.exercises[0].effectiveLogType, LogType.confirmOnly);
    expect(decoded.totalSets, plan.totalSets);
  });
}
