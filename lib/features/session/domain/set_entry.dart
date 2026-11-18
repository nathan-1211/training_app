import '../../../core/db/database.dart';
import '../../../core/enums.dart';
import '../../../core/format.dart';
import 'session_cursor.dart';
import 'session_plan.dart';

/// Valores digitados na janela de registro.
class SetEntry {
  const SetEntry({this.loadKg, this.reps, this.distanceM, this.durationSec});
  final double? loadKg;
  final int? reps;
  final double? distanceM;
  final int? durationSec;
}

/// Tudo que a janela de registro precisa mostrar.
class SheetData {
  const SheetData({
    required this.cursor,
    required this.exercise,
    required this.setNumber,
    required this.totalSets,
    required this.goalText,
    required this.lastTimeText,
    this.prefillLoad,
    this.prefillReps,
    this.prefillDistance,
    this.prefillDuration,
  });

  final SessionCursor cursor;
  final PlanExercise exercise;
  final int setNumber;
  final int totalSets;
  final String goalText;
  final String? lastTimeText;
  final double? prefillLoad;
  final int? prefillReps;
  final double? prefillDistance;
  final int? prefillDuration;

  LogType get logType => exercise.effectiveLogType;
}

String describeSet(SetLog s, LogType type) {
  switch (type) {
    case LogType.loadReps:
      return '${formatNumber(s.loadKg)} kg × ${s.reps ?? '–'}';
    case LogType.loadDistance:
      return '${formatNumber(s.loadKg)} kg · ${formatNumber(s.distanceM)} m';
    case LogType.repsOnly:
      return '${s.reps ?? '–'} reps';
    case LogType.timeOnly:
      return s.durationSec == null ? '–' : formatDuration(s.durationSec!);
    case LogType.confirmOnly:
      return 'feito';
  }
}

/// Monta a janela para o cursor atual.
/// [sessionLogs]: séries desta sessão; [lastTimeLogs]: séries do mesmo
/// exercício na última sessão em que ele foi feito (ordenadas).
SheetData buildSheetData({
  required SessionPlan plan,
  required SessionCursor cursor,
  required List<SetLog> sessionLogs,
  required List<SetLog> lastTimeLogs,
}) {
  final ex = plan.exercises[cursor.exerciseIndex];
  final type = ex.effectiveLogType;

  final thisExercise =
      sessionLogs.where((l) => l.exerciseIndex == cursor.exerciseIndex).toList()
        ..sort((a, b) => a.setIndex.compareTo(b.setIndex));
  final prevHere = thisExercise.isEmpty ? null : thisExercise.last;
  final lastSame = cursor.setIndex < lastTimeLogs.length
      ? lastTimeLogs[cursor.setIndex]
      : (lastTimeLogs.isEmpty ? null : lastTimeLogs.last);

  final goalParts = <String>[];
  if (ex.repsText.isNotEmpty) {
    goalParts.add(
      type == LogType.loadDistance ? ex.repsText : '${ex.repsText} reps',
    );
  }
  if (!ex.isWarmup && ex.rir.isNotEmpty) goalParts.add('RIR ${ex.rir}');

  String? lastText;
  if (!ex.isWarmup && lastTimeLogs.isNotEmpty) {
    lastText = lastTimeLogs.map((s) => describeSet(s, type)).join(' · ');
  }

  return SheetData(
    cursor: cursor,
    exercise: ex,
    setNumber: cursor.setIndex + 1,
    totalSets: ex.sets,
    goalText: goalParts.isEmpty ? 'Confirme a série' : goalParts.join(' · '),
    lastTimeText: lastText,
    prefillLoad: prevHere?.loadKg ?? lastSame?.loadKg,
    prefillReps: ex.target ?? prevHere?.reps ?? lastSame?.reps,
    prefillDistance:
        prevHere?.distanceM ?? lastSame?.distanceM ?? ex.target?.toDouble(),
    prefillDuration: prevHere?.durationSec ?? lastSame?.durationSec,
  );
}
