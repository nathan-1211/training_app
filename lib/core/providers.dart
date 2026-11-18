import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/blocks/data/block_repository.dart';
import '../features/session/data/session_repository.dart';
import 'db/database.dart';
import 'services/notification_service.dart';

/// Sobrescrito em main.dart (banco real) e nos testes (banco em memória).
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider não configurado'),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => LocalNotificationService(),
);

/// Relógio injetável.
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final blockRepositoryProvider = Provider(
  (ref) => BlockRepository(ref.watch(databaseProvider)),
);

final sessionRepositoryProvider = Provider(
  (ref) => SessionRepository(ref.watch(databaseProvider)),
);

/// Navigator raiz — usado para voltar à raiz quando chega um gatilho externo.
final navigatorKey = GlobalKey<NavigatorState>();

/// Executado quando chega um gatilho externo (toque duplo / App Intent):
/// fecha telas empilhadas para a janela aparecer direto na sessão.
final externalTriggerHookProvider = Provider<void Function()>((ref) {
  return () => navigatorKey.currentState?.popUntil((r) => r.isFirst);
});
