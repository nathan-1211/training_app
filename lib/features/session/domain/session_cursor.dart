import 'session_plan.dart';

/// Aponta para a próxima série a registrar: (exercício, série), ambos 0-based.
class SessionCursor {
  const SessionCursor(this.exerciseIndex, this.setIndex);
  static const start = SessionCursor(0, 0);

  final int exerciseIndex;
  final int setIndex;

  @override
  bool operator ==(Object other) =>
      other is SessionCursor &&
      other.exerciseIndex == exerciseIndex &&
      other.setIndex == setIndex;

  @override
  int get hashCode => Object.hash(exerciseIndex, setIndex);

  @override
  String toString() => 'SessionCursor($exerciseIndex, $setIndex)';
}

/// Regras de avanço do cursor — puras e testáveis.
class CursorLogic {
  const CursorLogic._();

  /// Primeiro cursor válido a partir de [from] (pula exercícios sem séries).
  /// null = não há mais nada (treino terminado).
  static SessionCursor? normalize(SessionPlan plan, SessionCursor from) {
    var ex = from.exerciseIndex;
    var set = from.setIndex;
    while (ex < plan.exercises.length) {
      if (set < plan.exercises[ex].sets) return SessionCursor(ex, set);
      ex++;
      set = 0;
    }
    return null;
  }

  /// Cursor depois de registrar a série em [current].
  /// - ainda há séries no exercício → próxima série;
  /// - completou o exercício → próximo exercício, série 1;
  /// - era a última série do último exercício → null (fim do treino).
  static SessionCursor? advance(SessionPlan plan, SessionCursor current) =>
      normalize(
        plan,
        SessionCursor(current.exerciseIndex, current.setIndex + 1),
      );

  /// Pula o restante do exercício atual.
  static SessionCursor? skipExercise(SessionPlan plan, SessionCursor current) =>
      normalize(plan, SessionCursor(current.exerciseIndex + 1, 0));
}
