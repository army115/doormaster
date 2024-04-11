// ignore_for_file: unused_import

import 'dart:developer';
import 'dart:io';

import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/routes/menu/notification_menu.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("BackgroundMessage ");
  if (message != null) {
    notifyKey.currentState?.push(
      GetPageRoute(
          page: () => Notification_Page(
                title: message.notification?.title,
                body: message.notification?.body,
              ),
          transitionDuration: Duration.zero),
    );
  }
}

void notificationTapBackground(NotificationResponse notificationResponse) {
  log('Selact_Background');
  bottomController.ontapItem(2);
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
    log("ForegroundMessage");

    // if (message != null) {
    //   notifyKey.currentState?.pushReplacement(
    //     GetPageRoute(
    //         page: () => Notification_Page(
    //               title: message.notification?.title,
    //               body: message.notification?.body,
    //             ),
    //         transitionDuration: Duration.zero),
    //   );
    // }
  }

  Future<void> notification() async {
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final String? fCMToken = await messaging.getToken();
    log("TokenNotify : ${fCMToken}");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("notifyToken", fCMToken ?? '');

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
      requestCriticalPermission: true,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: (details) {
        log('Selact_Foreground');
        bottomController.ontapItem(2);
      },
    );

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen(handleMessage);
    // if (Platform.isAndroid) {
    //   FirebaseMessaging.onMessage.listen(handleMessage);
    // } else {
    //   FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    // }
  }
}
