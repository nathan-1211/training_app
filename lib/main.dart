import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/db/database.dart';
import 'core/providers.dart';
import 'core/services/notification_service.dart';
import 'features/trigger/data/trigger_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifications = LocalNotificationService();
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(AppDatabase.open()),
      notificationServiceProvider.overrideWithValue(notifications),
    ],
  );

  // Começa a ouvir gatilhos (link inicial, stream, App Intent) antes do
  // primeiro frame. Eles ficam na fila até a sessão sair do banco.
  final triggers = TriggerService(container, PlatformTriggerSources());
  unawaited(triggers.start());
  unawaited(notifications.init());

  runApp(
    UncontrolledProviderScope(container: container, child: const TreinoApp()),
  );
}
