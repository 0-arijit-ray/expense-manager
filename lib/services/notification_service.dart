import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../core/formatters.dart';
import '../data/local/database.dart';

/// Wraps flutter_local_notifications for EMI / payment reminders.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const _channel = AndroidNotificationChannel(
    'emi_reminders',
    'EMI & Payment Reminders',
    description: 'Reminders for upcoming loan EMIs and bills',
    importance: Importance.high,
  );

  Future<void> init() async {
    if (_ready) return;
    // No web implementation for local notifications; treat as a no-op.
    if (kIsWeb) {
      _ready = true;
      return;
    }
    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation(await _deviceTimeZone()));
    } catch (_) {
      // Fall back to whatever local() resolves to.
    }

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings: settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
    _ready = true;
  }

  Future<String> _deviceTimeZone() async {
    // Lightweight heuristic; defaults to local. Apps may plug in flutter_timezone.
    return tz.local.name;
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return false;
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission() ?? true;
    await android?.requestExactAlarmsPermission();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
    return granted;
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          'emi_reminders',
          'EMI & Payment Reminders',
          channelDescription: 'Reminders for upcoming loan EMIs and bills',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      );

  /// Schedules a reminder [leadDays] before the EMI due date at 9am.
  Future<void> scheduleEmiReminder({
    required Loan loan,
    required EmiSchedule emi,
  }) async {
    if (kIsWeb) return;
    await init();
    final fireDate = DateTime(
      emi.dueDate.year,
      emi.dueDate.month,
      emi.dueDate.day,
      9,
    ).subtract(Duration(days: loan.alertLeadDays));
    if (fireDate.isBefore(DateTime.now())) return;

    final when = tz.TZDateTime.from(fireDate, tz.local);
    try {
      await _plugin.zonedSchedule(
        id: emi.id,
        title: '${loan.name} EMI due soon',
        body:
            '${Money.format(emi.emiAmount)} due on ${Dates.dayShort(emi.dueDate)}',
        scheduledDate: when,
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint('Failed to schedule EMI reminder: $e');
    }
  }

  Future<void> cancel(int id) async {
    if (kIsWeb) return;
    await init();
    await _plugin.cancel(id: id);
  }

  Future<void> cancelAll() async {
    if (kIsWeb) return;
    await init();
    await _plugin.cancelAll();
  }

  /// Rebuilds reminders for every upcoming, unpaid EMI.
  Future<void> rescheduleAll(
      List<({EmiSchedule emi, Loan loan})> upcoming) async {
    await init();
    for (final item in upcoming) {
      if (item.loan.alertsEnabled) {
        await scheduleEmiReminder(loan: item.loan, emi: item.emi);
      }
    }
  }
}
