import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training/core/db/database.dart';
import 'package:training/core/providers.dart';
import 'package:training/core/services/notification_service.dart';

/// Segunda-feira, 16/11/2026, 10:00 — semana 1 do Bloco 1 semeado.
final mondayW1 = DateTime(2026, 11, 16, 10);

/// Relógio controlável nos testes.
class TestClock {
  TestClock(this.now);
  DateTime now;
  DateTime call() => now;
  void advance(Duration d) => now = now.add(d);
}

AppDatabase memoryDb({DateTime? seedAt, bool seed = true}) {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  return AppDatabase(
    NativeDatabase.memory(),
    seedOnCreate: seed,
    now: () => seedAt ?? mondayW1,
  );
}

ProviderContainer makeContainer(
  AppDatabase db, {
  TestClock? clock,
  NotificationService? notifications,
  void Function()? onExternalTrigger,
  List overrides = const [],
}) {
  final c = clock ?? TestClock(mondayW1);
  return ProviderContainer.test(
    overrides: [
      databaseProvider.overrideWithValue(db),
      clockProvider.overrideWithValue(c.call),
      notificationServiceProvider.overrideWithValue(
        notifications ?? NoopNotificationService(),
      ),
      externalTriggerHookProvider.overrideWithValue(onExternalTrigger ?? () {}),
      ...overrides,
    ],
  );
}
