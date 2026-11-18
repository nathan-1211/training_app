import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Só usado para o fim do descanso.
abstract class NotificationService {
  Future<void> init();
  Future<void> requestPermission();

  /// Agenda (ou substitui) o aviso de fim de descanso.
  Future<void> scheduleRestEnd(DateTime at, {required String body});
  Future<void> cancelRestEnd();
}

class LocalNotificationService implements NotificationService {
  static const _restId = 1001;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  @override
  Future<void> init() async {
    if (_initialized) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
      ),
    );
    _initialized = true;
  }

  @override
  Future<void> requestPermission() async {
    await init();
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, sound: true);
  }

  @override
  Future<void> scheduleRestEnd(DateTime at, {required String body}) async {
    await init();
    await _plugin.cancel(id: _restId);
    if (!at.isAfter(DateTime.now())) return;
    // Agendado em UTC: o instante é absoluto, não depende do fuso.
    await _plugin.zonedSchedule(
      id: _restId,
      title: 'Descanso terminou',
      body: body,
      scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBanner: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.active,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelRestEnd() async {
    await init();
    await _plugin.cancel(id: _restId);
  }
}

/// Implementação vazia para testes.
class NoopNotificationService implements NotificationService {
  final scheduled = <DateTime>[];
  int cancels = 0;

  @override
  Future<void> init() async {}
  @override
  Future<void> requestPermission() async {}
  @override
  Future<void> scheduleRestEnd(DateTime at, {required String body}) async =>
      scheduled.add(at);
  @override
  Future<void> cancelRestEnd() async => cancels++;
}
