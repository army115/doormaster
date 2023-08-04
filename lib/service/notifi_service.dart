// ignore_for_file: unused_import

import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Title : ${message.notification?.title}");
  log("Bdy : ${message.notification?.body}");
  log("Data : ${message.data}");
}

class NotificationService {
  final messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> handleMessage(RemoteMessage message) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidChannel = AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'icon_app',
      channelShowBadge: true,
      styleInformation: bigTextStyleInformation,
      // color: Theme.of(context).primaryColor,
      // largeIcon: DrawableResourceAndroidBitmap('circle_icon'),
    );
    DarwinNotificationDetails iosChannel = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    await flutterLocalNotificationsPlugin.show(1, message.notification?.title,
        message.notification?.body, platformChannel,
        payload: message.data['body']);
    log("Title : ${message.notification?.title}");
    log("Bdy : ${message.notification?.body}");
    log("Data : ${message.data}");
  }

  Future<void> notification() async {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
    final fCMToken = await messaging.getToken();
    log("Token : ${fCMToken}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("notifyToken", fCMToken!);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('icon_app');

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

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
  }

  Future<void> showNotification(context) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'id', 'แจ้งเตือนปกติ',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'icon_app',
      channelShowBadge: true,
      color: Theme.of(context).primaryColor,
      // largeIcon: DrawableResourceAndroidBitmap('circle_icon'),
    );

    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
        badgeNumber: 0, subtitle: 'การแจ้งเตือนใหม่');

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
