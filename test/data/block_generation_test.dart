import 'package:flutter_test/flutter_test.dart';
import 'package:training/core/enums.dart';
import 'package:training/features/blocks/data/block_repository.dart';
import 'package:training/features/blocks/domain/block_generator.dart';
import 'package:training/features/blocks/domain/block_spec.dart';
import 'package:training/features/blocks/domain/seed_block1.dart';

import '../helpers.dart';

void main() {
  group('geração pura', () {
    test('Bloco 1: 4 sessões por semana × 8 semanas, nos dias certos', () {
      final spec = seedBlock1(now: mondayW1);
      final planned = generatePlannedSessions(spec);
      expect(planned.length, 32);
      final w1 = planned.where((p) => p.week == 1).toList();
      expect(w1.map((p) => p.date.weekday), [
        DateTime.monday,
        DateTime.tuesday,
        DateTime.thursday,
        DateTime.saturday,
      ]);
      expect(w1.map((p) => p.kind), [
        DayKind.strength,
        DayKind.run,
        DayKind.strength,
        DayKind.conditioning,
      ]);
      expect(w1[0].workoutIndex, 0); // Força A
      expect(w1[2].workoutIndex, 1); // Força B
      expect(planned.last.week, 8);
      expect(planned.last.date, DateTime(2027, 1, 9)); // sábado da semana 8
    });

    test('início fora da segunda: a semana conta da data de início', () {
      final spec = seedBlock1(now: mondayW1)
        ..startDate =
            DateTime(2026, 11, 18) // quarta
        ..weeks = 1;
      final planned = generatePlannedSessions(spec);
      // qua..ter: qui (B), sáb (cond), seg (A), ter (corrida)
      expect(planned.map((p) => p.date.weekday), [4, 6, 1, 2]);
    });

    test('semana do bloco por data', () {
      final start = DateTime(2026, 11, 16);
      expect(
        blockWeekFor(
          startDate: start,
          weeks: 8,
          date: DateTime(2026, 11, 22, 23),
        ),
        1,
      );
      expect(
        blockWeekFor(startDate: start, weeks: 8, date: DateTime(2026, 11, 23)),
        2,
      );
      expect(
        blockWeekFor(startDate: start, weeks: 8, date: DateTime(2026, 11, 15)),
        isNull,
      );
      expect(
        blockWeekFor(startDate: start, weeks: 8, date: DateTime(2027, 1, 11)),
        isNull,
      );
    });

    test('parse de reps alvo', () {
      expect(parseRepsRange('6–8'), (min: 6, max: 8));
      expect(parseRepsRange('10/lado'), (min: 10, max: 10));
      expect(parseRepsRange('30–40 m'), (min: 30, max: 40));
      expect(parseRepsRange(''), (min: null, max: null));
    });

    test('remover treino corrige a agenda', () {
      final spec = seedBlock1(now: mondayW1)..removeWorkout(0);
      expect(spec.dayFor(DateTime.monday).kind, DayKind.rest);
      expect(spec.dayFor(DateTime.thursday).workoutIndex, 0);
    });
  });

  group('banco', () {
    test('seed cria o Bloco 1 ativo com treinos, semanas e sessões', () async {
      final db = memoryDb();
      addTearDown(db.close);
      final repo = BlockRepository(db);
      final block = (await repo.activeBlock())!;
      expect(block.name, 'Bloco 1');
      expect(block.startDate, DateTime(2026, 11, 16));
      final templates = await repo.templatesOf(block.id);
      expect(templates.map((t) => t.name), ['Força A', 'Força B']);
      final a = await repo.templateExercises(templates[0].id);
      expect(a.length, 9);
      expect(a.where((r) => r.te.isWarmup).length, 3);
      expect(a[3].exercise.name, 'Terra com trap bar');
      expect(a[3].te.restSec, 150);
      final b = await repo.templateExercises(templates[1].id);
      expect(b.last.te.logType, LogType.loadDistance);
      expect((await repo.plannedOf(block.id)).length, 32);
      expect((await repo.weeksOf(block.id))[6].mainSets, 4);
    });

    test('tela inicial: segunda da semana 3 = "Força A"', () async {
      final db = memoryDb();
      addTearDown(db.close);
      final plan = await BlockRepository(db).dayPlan(DateTime(2026, 11, 30, 9));
      expect(plan!.week, 3);
      expect(plan.kind, DayKind.strength);
      expect(plan.template!.name, 'Força A');
      expect(plan.weekRow!.mainSets, 3);
      final tue = await BlockRepository(db).dayPlan(DateTime(2026, 12, 8));
      expect(tue!.kind, DayKind.run);
      expect(tue.weekRow!.runPrescription, "5× (4' corre / 1' caminha)");
    });

    test('duplicar e editar bloco', () async {
      final db = memoryDb();
      addTearDown(db.close);
      final repo = BlockRepository(db);
      final b1 = (await repo.activeBlock())!;
      final b2 = await repo.duplicate(b1.id);
      final spec = await repo.loadSpec(b2);
      expect(spec.name, 'Bloco 2');
      expect(spec.startDate, DateTime(2027, 1, 11));
      expect(spec.workouts[1].exercises.length, 10);

      spec.weeks = 4;
      spec.normalizeWeeks();
      spec.schedule[DateTime.saturday] = const DaySpec.rest();
      await repo.updateFromSpec(b2, spec);
      expect((await repo.plannedOf(b2)).length, 12);
      expect((await repo.weeksOf(b2)).length, 4);
      // Bloco original intacto.
      expect((await repo.plannedOf(b1.id)).length, 32);
      // Exercícios compartilhados por nome (histórico entre blocos).
      final ex = await db.select(db.exercises).get();
      expect(ex.length, 19);
    });
  });
}
