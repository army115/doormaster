// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/bottombar/bottom_controller.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/routes/menu/notification_menu.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Background Message: ${message.notification?.title}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    final fcmToken = await _messaging.getToken();
    log("FCM Token: $fcmToken");

    await SecureStorageUtils.writeString("notifyToken", fcmToken ?? '');

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    await _initializeLocalNotifications();

    _setupFirebaseListeners();
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('icon_app');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        onNotificationTap(details.payload);
        // final payloadData = jsonDecode(details.payload!);
        // log("payloadData: ${payloadData['route']}");
        // log("payloadData: ${payloadData['route']}");
        // Get.toNamed(payloadData['route'], arguments: payloadData['data']);
        // _onNotificationTap(details.payload);
      },
    );
  }

  void _setupFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground Message: ${message.notification?.title}");
      log("Data Message: ${message.data}");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification Clicked: ${message.notification?.title}");
      // String payload = jsonEncode(message.data);
      Get.toNamed(message.data['route'], arguments: message.data['data']);
      // _onNotificationTap(payload);
    });

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'icon_app',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
    );

    String payloadData = jsonEncode(message.data);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformDetails,
      payload: payloadData,
    );
    if (bottomController.selectedIndex == 2) {
      bottomController.notificationCount.value = 0;
    } else {
      bottomController.notificationCount++;
    }
    bottomController.notifications.add(message.data['data']);
  }

  void onNotificationTap(payload) {
    final payloadData = jsonDecode(payload);
    log("route: ${payloadData['route']}");
    log("data: ${payloadData['data']}");
    Get.offNamed(payload['route'], arguments: payload['data']);
  }
}
