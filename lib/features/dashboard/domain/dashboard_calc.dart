import '../../../core/db/database.dart';
import '../../../core/enums.dart';
import '../../blocks/domain/block_generator.dart';
import 'strength_math.dart';

class E1rmPoint {
  const E1rmPoint({
    required this.date,
    required this.e1rm,
    required this.bestLoad,
    required this.isE1rmPr,
    required this.isLoadPr,
  });
  final DateTime date;
  final double e1rm;
  final double bestLoad;
  final bool isE1rmPr;
  final bool isLoadPr;
}

/// 1RM estimado por sessão (melhor série da sessão) para um exercício,
/// marcando recordes (PR de 1RM estimado e de carga) em relação ao passado.
List<E1rmPoint> e1rmSeries(
  int exerciseId,
  List<Session> sessions,
  List<SetLog> logs,
) {
  final byId = {for (final s in sessions) s.id: s};
  final bySession = <int, List<SetLog>>{};
  for (final l in logs) {
    if (l.exerciseId != exerciseId || l.isWarmup) continue;
    if (l.loadKg == null || l.reps == null || !byId.containsKey(l.sessionId)) {
      continue;
    }
    bySession.putIfAbsent(l.sessionId, () => []).add(l);
  }
  final ordered = bySession.keys.toList()
    ..sort((a, b) => byId[a]!.startedAt.compareTo(byId[b]!.startedAt));
  var maxE1 = 0.0;
  var maxLoad = 0.0;
  final points = <E1rmPoint>[];
  for (final id in ordered) {
    final sets = bySession[id]!.map((l) => LoadedSet(l.loadKg!, l.reps!));
    final e1 = bestE1RM(sets);
    final load = bestLoad(sets);
    points.add(
      E1rmPoint(
        date: byId[id]!.startedAt,
        e1rm: e1,
        bestLoad: load,
        isE1rmPr: points.isNotEmpty && e1 > maxE1,
        isLoadPr: points.isNotEmpty && load > maxLoad,
      ),
    );
    if (e1 > maxE1) maxE1 = e1;
    if (load > maxLoad) maxLoad = load;
  }
  return points;
}

class WeekVolume {
  WeekVolume(this.weekStart);
  final DateTime weekStart;
  final Map<String, double> volumeByTemplate = {};
  int effectiveSets = 0;
  double get total => volumeByTemplate.values.fold(0, (a, b) => a + b);
}

/// Volume (carga × reps) por semana (segunda-feira) e por treino, e
/// número de séries efetivas (sem aquecimento).
List<WeekVolume> weeklyVolume(List<Session> sessions, List<SetLog> logs) {
  final byId = {for (final s in sessions) s.id: s};
  final weeks = <DateTime, WeekVolume>{};
  for (final l in logs) {
    final s = byId[l.sessionId];
    if (s == null || l.isWarmup) continue;
    final key = mondayOf(s.startedAt);
    final w = weeks.putIfAbsent(key, () => WeekVolume(key));
    w.effectiveSets++;
    if (l.loadKg != null && l.reps != null) {
      w.volumeByTemplate[s.templateName] =
          (w.volumeByTemplate[s.templateName] ?? 0) + l.loadKg! * l.reps!;
    }
  }
  return weeks.values.toList()
    ..sort((a, b) => a.weekStart.compareTo(b.weekStart));
}

class WeekAdherence {
  const WeekAdherence(this.week, this.planned, this.done);
  final int week;
  final int planned;
  final int done;
  double get ratio => planned == 0 ? 1 : done / planned;
  bool get fulfilled => done >= planned;
}

/// Aderência por semana do bloco. Para cada tipo (força, corrida,
/// condicionamento) conta min(feitas, planejadas) — fazer o treino em outro
/// dia da mesma semana também vale.
List<WeekAdherence> adherence({
  required Block block,
  required List<PlannedSession> planned,
  required List<Session> sessions,
  required List<CardioLog> cardio,
}) {
  final result = <WeekAdherence>[];
  for (var week = 1; week <= block.weeks; week++) {
    final p = planned.where((x) => x.weekNumber == week);
    int plannedOf(DayKind k) => p.where((x) => x.kind == k).length;
    int weekOf(DateTime d) =>
        blockWeekFor(startDate: block.startDate, weeks: block.weeks, date: d) ??
        -1;
    final strengthDone = sessions
        .where(
          (s) =>
              s.status == SessionStatus.finished && weekOf(s.startedAt) == week,
        )
        .length;
    final runDone = cardio
        .where((c) => c.type == CardioType.run && weekOf(c.date) == week)
        .length;
    final condDone = cardio
        .where((c) => c.type.isConditioning && weekOf(c.date) == week)
        .length;
    int capped(int done, DayKind k) =>
        done > plannedOf(k) ? plannedOf(k) : done;
    final total = p.length;
    final done =
        capped(strengthDone, DayKind.strength) +
        capped(runDone, DayKind.run) +
        capped(condDone, DayKind.conditioning);
    result.add(WeekAdherence(week, total, done));
  }
  return result;
}

/// Sequência atual de semanas cumpridas, até [currentWeek]. A semana atual só
/// entra se já estiver cumprida (ela ainda não acabou).
int fulfilledStreak(List<WeekAdherence> weeks, int currentWeek) {
  var streak = 0;
  for (var w = currentWeek; w >= 1; w--) {
    final a = weeks.where((x) => x.week == w).firstOrNull;
    if (a == null) continue;
    if (a.fulfilled) {
      streak++;
    } else if (w == currentWeek) {
      continue;
    } else {
      break;
    }
  }
  return streak;
}

class WeekValue {
  const WeekValue(this.weekStart, this.value, [this.secondary]);
  final DateTime weekStart;
  final double value;
  final double? secondary;
}

List<WeekValue> kmPerWeek(List<CardioLog> cardio) {
  final m = <DateTime, double>{};
  for (final c in cardio.where((c) => c.type == CardioType.run)) {
    final k = mondayOf(c.date);
    m[k] = (m[k] ?? 0) + (c.km ?? 0);
  }
  return m.entries.map((e) => WeekValue(e.key, e.value)).toList()
    ..sort((a, b) => a.weekStart.compareTo(b.weekStart));
}

/// Minutos (value) e RPE médio (secondary) de condicionamento por semana.
List<WeekValue> conditioningPerWeek(List<CardioLog> cardio) {
  final mins = <DateTime, double>{};
  final rpes = <DateTime, List<int>>{};
  for (final c in cardio.where((c) => c.type.isConditioning)) {
    final k = mondayOf(c.date);
    mins[k] = (mins[k] ?? 0) + c.durationSec / 60;
    if (c.rpe != null) rpes.putIfAbsent(k, () => []).add(c.rpe!);
  }
  return mins.entries.map((e) {
    final r = rpes[e.key];
    return WeekValue(
      e.key,
      e.value,
      r == null ? null : r.reduce((a, b) => a + b) / r.length,
    );
  }).toList()..sort((a, b) => a.weekStart.compareTo(b.weekStart));
}

const distanceBands = <(String, double, double)>[
  ('< 3 km', 0, 3),
  ('3–5 km', 3, 5),
  ('5–10 km', 5, 10),
  ('10+ km', 10, double.infinity),
];

class RunStats {
  const RunStats({
    required this.paceTrend,
    required this.longestSec,
    required this.bestPaceByBand,
  });
  final List<(DateTime, int)> paceTrend;
  final int? longestSec;
  final Map<String, int> bestPaceByBand;
}

RunStats runStats(List<CardioLog> cardio) {
  final runs =
      cardio
          .where((c) => c.type == CardioType.run && c.paceSecPerKm != null)
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
  final best = <String, int>{};
  for (final r in runs) {
    for (final band in distanceBands) {
      if (r.km! >= band.$2 && r.km! < band.$3) {
        final cur = best[band.$1];
        if (cur == null || r.paceSecPerKm! < cur) {
          best[band.$1] = r.paceSecPerKm!;
        }
      }
    }
  }
  final allRuns = cardio.where((c) => c.type == CardioType.run);
  return RunStats(
    paceTrend: [for (final r in runs) (r.date, r.paceSecPerKm!)],
    longestSec: allRuns.isEmpty
        ? null
        : allRuns.map((r) => r.durationSec).reduce((a, b) => a > b ? a : b),
    bestPaceByBand: best,
  );
}
