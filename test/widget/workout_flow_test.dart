import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:training/app.dart';
import 'package:training/core/db/database.dart';
import 'package:training/core/providers.dart';
import 'package:training/core/services/notification_service.dart';

import '../helpers.dart';

void main() {
  testWidgets('iniciar → registrar todas as séries → treino encerrado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    late AppDatabase db;
    await tester.runAsync(() async {
      db = memoryDb();
      // Força a abertura (seed) fora do relógio falso.
      await db.select(db.blocks).get();
    });
    final clock = TestClock(mondayW1);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(clock.call),
          notificationServiceProvider.overrideWithValue(
            NoopNotificationService(),
          ),
        ],
        child: const TreinoApp(),
      ),
    );

    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 5)),
        );
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    await settle();
    expect(find.text('Semana 1 · Força A'), findsOneWidget);

    await tester.tap(find.byKey(const Key('start-workout')));
    await settle();
    expect(find.byKey(const Key('register-set')), findsOneWidget);

    var sets = 0;
    while (find.byKey(const Key('register-set')).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(const Key('register-set')));
      await settle();
      expect(find.textContaining('Série '), findsWidgets);
      final load = find.byKey(const Key('field-load'));
      if (load.evaluate().isNotEmpty) {
        await tester.enterText(load, '30');
      }
      await tester.tap(find.byKey(const Key('sheet-ok')));
      await settle();
      sets++;
      clock.advance(const Duration(minutes: 3));
      expect(sets, lessThanOrEqualTo(18));
    }

    expect(sets, 18);
    expect(find.text('Treino encerrado'), findsOneWidget);
    expect(find.text('Força A'), findsOneWidget);

    await tester.tap(find.byKey(const Key('summary-done')));
    await settle();
    expect(find.byKey(const Key('start-workout')), findsOneWidget);

    await tester.runAsync(db.close);
  });
}
