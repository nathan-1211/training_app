import '../../../core/enums.dart';
import 'block_generator.dart';
import 'block_spec.dart';

ExerciseSpec _warm(String name, String reps, String tip) {
  final r = parseRepsRange(reps);
  return ExerciseSpec(
    name: name,
    logType: LogType.confirmOnly,
    isWarmup: true,
    repsText: reps,
    repsMin: r.min,
    repsMax: r.max,
    restSec: 0,
    tip: tip,
    fixedSets: 2,
  );
}

ExerciseSpec _main(
  String name,
  String reps,
  int rest,
  String tip, {
  LogType type = LogType.loadReps,
}) {
  final r = parseRepsRange(reps);
  return ExerciseSpec(
    name: name,
    logType: type,
    repsText: reps,
    repsMin: r.min,
    repsMax: r.max,
    restSec: rest,
    tip: tip,
  );
}

/// Bloco 1 (8 semanas), semeado na primeira instalação.
/// Começa na segunda-feira da semana em que o app foi instalado.
BlockSpec seedBlock1({DateTime? now}) {
  final forcaA = WorkoutSpec(
    name: 'Força A',
    exercises: [
      _warm(
        'Aq. Mobilização joelho-parede com elástico',
        '10/lado',
        'Joelho passa da ponta do pé, calcanhar no chão',
      ),
      _warm(
        'Aq. Passada lateral com mini-band',
        '12/lado',
        'Joelho não cai para dentro',
      ),
      _warm(
        'Aq. Prancha lateral com abdução',
        '8/lado',
        'Sinta o glúteo médio, não o TFL',
      ),
      _main(
        'Terra com trap bar',
        '6–8',
        150,
        'Quadril e joelho estendem juntos',
      ),
      _main(
        'Agachamento goblet, calcanhar elevado',
        '8–10',
        120,
        'Anilha sob o calcanhar; tronco ereto',
      ),
      _main('Afundo búlgaro', '8/perna', 90, 'Joelho alinhado com o 2º dedo'),
      _main(
        'Remada unilateral com halter',
        '10/lado',
        90,
        'Escápula para trás e para baixo',
      ),
      _main(
        'Panturrilha excêntrica em pé',
        '12',
        60,
        '3 s descendo, amplitude total',
      ),
      _main('Pallof press', '10/lado', 60, 'Resista à rotação'),
    ],
  );

  final forcaB = WorkoutSpec(
    name: 'Força B',
    exercises: [
      _warm('Aq. Chin tuck', '10', 'Queixo para trás, sem inclinar'),
      _warm('Aq. Open book', '8/lado', 'Gira o tronco, não o quadril'),
      _warm('Aq. Face pull leve', '15', 'Cotovelos altos'),
      _main(
        'Puxada alta (ou barra com elástico)',
        '6–10',
        120,
        'Pegada neutra se o ombro reclamar',
      ),
      _main('Supino com halteres', '8–10', 120, 'Cotovelo ~45°'),
      _main('Remada apoiada no banco', '10–12', 90, 'Pausa 1 s em cima'),
      _main(
        'Desenvolvimento meio-ajoelhado unilateral',
        '8/lado',
        90,
        'Glúteo da perna de trás contraído',
      ),
      _main('Elevação pélvica', '10', 90, 'Pausa 1 s no topo'),
      _main('Face pull', '15', 60, 'Puxar mais do que empurrar'),
      _main(
        'Farmer carry',
        '30–40 m',
        60,
        'Postura alta',
        type: LogType.loadDistance,
      ),
    ],
  );

  WeekSpec w(
    int week,
    String phase,
    int sets,
    String rir,
    String run,
    String cond,
  ) => WeekSpec(
    week: week,
    phase: phase,
    mainSets: sets,
    rir: rir,
    run: run,
    conditioning: cond,
  );

  return BlockSpec(
    name: 'Bloco 1',
    startDate: mondayOf(now ?? DateTime.now()),
    weeks: 8,
    workouts: [forcaA, forcaB],
    schedule: {
      DateTime.monday: const DaySpec(kind: DayKind.strength, workoutIndex: 0),
      DateTime.tuesday: const DaySpec(kind: DayKind.run),
      DateTime.thursday: const DaySpec(kind: DayKind.strength, workoutIndex: 1),
      DateTime.saturday: const DaySpec(kind: DayKind.conditioning),
    },
    weekSpecs: [
      w(
        1,
        'Readaptação',
        2,
        '3–4',
        "5' caminhada + 8× (1' corre / 2' caminha)",
        "EMOM 12' leve (RPE ≤ 6) + testes iniciais",
      ),
      w(
        2,
        'Readaptação',
        2,
        '3–4',
        "8× (2' corre / 2' caminha)",
        "EMOM 14' (RPE ≤ 6)",
      ),
      w(
        3,
        'Construção',
        3,
        '3',
        "6× (3' corre / 1'30 caminha)",
        "EMOM 16' (RPE ≤ 7)",
      ),
      w(
        4,
        'Construção',
        3,
        '3',
        "5× (4' corre / 1' caminha)",
        "EMOM 16' (RPE ≤ 7)",
      ),
      w(
        5,
        'Progressão',
        3,
        '2–3',
        "3× (8' corre / 1' caminha)",
        "EMOM 18' ou cross escalado (RPE ≤ 8)",
      ),
      w(
        6,
        'Progressão',
        3,
        '2',
        "2× (12' corre / 1' caminha)",
        "EMOM 20' ou cross",
      ),
      w(
        7,
        'Progressão',
        4,
        '2',
        "20' contínuos em ritmo de conversa",
        "EMOM 20' ou cross",
      ),
      w(8, 'Deload + testes', 2, '4', "25' contínuos leves", 'Testes finais'),
    ],
  );
}
