// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> notification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("icon_app");

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            requestCriticalPermission: true);
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> showNotification() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'id',
      'แจ้งเตือนปกติ',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "icon_app",
      channelShowBadge: true,
      // largeIcon: DrawableResourceAndroidBitmap('circle_icon'),
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
        badgeNumber: 1, subtitle: 'test notification ios');

    NotificationDetails generalNotificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'ทดสอบ',
      'การแจ้งเตือน',
      generalNotificationDetails,
    );
  }
}
