import 'package:flutter_test/flutter_test.dart';
import 'package:training/core/enums.dart';
import 'package:training/features/blocks/data/block_repository.dart';
import 'package:training/features/cardio/data/cardio_repository.dart';
import 'package:training/features/dashboard/data/dashboard_repository.dart';
import 'package:training/features/dashboard/domain/dashboard_calc.dart';
import 'package:training/features/session/domain/set_entry.dart';
import 'package:training/features/session/presentation/session_controller.dart';
import 'package:training/features/settings/data/backup_service.dart';

import '../helpers.dart';

void main() {
  test('backup: exportar e importar preserva tudo', () async {
    final db = memoryDb();
    addTearDown(db.close);
    final c = makeContainer(db);
    final ctrl = c.read(sessionControllerProvider.notifier);
    await c.read(sessionControllerProvider.future);
    final block = (await BlockRepository(db).activeBlock())!;
    final tId = (await BlockRepository(db).templatesOf(block.id)).first.id;
    await ctrl.start(tId);
    await ctrl.onRegisterTrigger();
    await ctrl.confirmSet(const SetEntry());
    await CardioRepository(db).save(
      type: CardioType.run,
      date: mondayW1,
      durationSec: 1290,
      km: 3.2,
      rpe: 6,
    );

    final json = await BackupService(db).exportJson();

    final other = memoryDb(seed: false);
    addTearDown(other.close);
    await BackupService(other).importJson(json);
    expect((await other.select(other.blocks).get()).single.name, 'Bloco 1');
    expect((await other.select(other.plannedSessions).get()).length, 32);
    final s = (await other.select(other.sessions).get()).single;
    expect(s.status, SessionStatus.active);
    expect(s.cursorSet, 1);
    expect((await other.select(other.setLogs).get()).length, 1);
    final run = (await other.select(other.cardioLogs).get()).single;
    expect(run.paceSecPerKm, 403);
    expect(run.km, 3.2);
    expect(run.weekNumber, 1);

    // Reimportar por cima não duplica.
    await BackupService(other).importJson(json);
    expect((await other.select(other.setLogs).get()).length, 1);
    expect(
      () => BackupService(other).importJson('{"x":1}'),
      throwsA(isA<FormatException>()),
    );
  });

  test('dashboard: 1RM, PRs, volume, aderência e corrida', () async {
    final db = memoryDb();
    addTearDown(db.close);
    final clock = TestClock(mondayW1);
    final c = makeContainer(db, clock: clock);
    final ctrl = c.read(sessionControllerProvider.notifier);
    await c.read(sessionControllerProvider.future);
    final block = (await BlockRepository(db).activeBlock())!;
    final templates = await BlockRepository(db).templatesOf(block.id);

    Future<void> doWorkout(int templateId, double load) async {
      await ctrl.start(templateId);
      while (c.read(sessionControllerProvider).value!.active != null) {
        await ctrl.onRegisterTrigger();
        final sheet = c.read(sessionControllerProvider).value!.sheet!;
        await ctrl.confirmSet(
          SetEntry(
            loadKg: sheet.logType.hasLoad ? load : null,
            reps: sheet.prefillReps,
            distanceM: sheet.prefillDistance,
          ),
        );
      }
      ctrl.dismissSummary();
    }

    await doWorkout(templates[0].id, 50); // seg S1
    clock.advance(const Duration(days: 3));
    await doWorkout(templates[1].id, 20); // qui S1
    await CardioRepository(db).save(
      type: CardioType.run,
      date: mondayW1.add(const Duration(days: 1)),
      durationSec: 1290,
      km: 3.2,
    );
    await CardioRepository(db).save(
      type: CardioType.emom,
      date: mondayW1.add(const Duration(days: 5)),
      durationSec: 12 * 60,
      rpe: 6,
    );
    clock.advance(const Duration(days: 4));
    await doWorkout(templates[0].id, 60); // seg S2: PR

    final d = await DashboardRepository(db).load(blockId: block.id);
    final terra = d.exercises.firstWhere((e) => e.name == 'Terra com trap bar');
    final series = e1rmSeries(terra.id, d.sessions, d.logs);
    expect(series.length, 2);
    expect(series[0].e1rm, closeTo(50 * (1 + 8 / 30), 0.001));
    expect(series[1].isE1rmPr, isTrue);
    expect(series[1].isLoadPr, isTrue);

    final vol = weeklyVolume(d.sessions, d.logs);
    expect(vol.length, 2);
    expect(vol[0].volumeByTemplate.keys, containsAll(['Força A', 'Força B']));
    expect(vol[0].effectiveSets, 12 + 14); // A: 6×2, B: 7×2

    final adh = adherence(
      block: block,
      planned: d.planned,
      sessions: d.sessions,
      cardio: d.cardio,
    );
    expect(adh[0].planned, 4);
    expect(adh[0].done, 4);
    expect(adh[1].done, 1);
    expect(fulfilledStreak(adh, 2), 1);

    expect(kmPerWeek(d.cardio).single.value, 3.2);
    final run = runStats(d.cardio);
    expect(run.bestPaceByBand['3–5 km'], 403);
    expect(run.longestSec, 1290);
    final cond = conditioningPerWeek(d.cardio).single;
    expect(cond.value, 12);
    expect(cond.secondary, 6);
  });
}
