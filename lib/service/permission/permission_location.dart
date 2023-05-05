import 'dart:io';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> permissionLocation(context, action) async {
  final permission = await Permission.location.request();
  final location = await Geolocator.isLocationServiceEnabled();
  print(permission);
  print("location : $location");

  if (Platform.isAndroid) {
    print('android');
    if (permission.isGranted) {
      await action();
    } else {
      dialogOnebutton_Subtitle(
          context,
          'อนุญาตการเข้าถึง',
          'จำเป็นต้องเข้าถึงตำแหน่งอุปกรณ์ของคุณ',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        openAppSettings();

        Navigator.of(context, rootNavigator: true).pop();
      }, true, true);
    }
  } else if (Platform.isIOS) {
    print("apple");
    if (permission.isGranted && location) {
      await action();
    } else if (!location) {
      dialogOnebutton_Subtitle(
          context,
          'การเข้าถึงตำแหน่งที่ตั้ง',
          'เปิดบริการตำแหน่งที่ตั้งอุปกรณ์ของคุณ',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () async {
        await launch('App-Prefs:LOCATION_SERVICES');

        Navigator.of(context, rootNavigator: true).pop();
      }, true, true);
    } else {
      dialogOnebutton_Subtitle(
          context,
          'อนุญาตการเข้าถึง',
          'จำเป็นต้องเข้าถึงตำแหน่งอุปกรณ์ของคุณ',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        print('setting');
        openAppSettings();

        Navigator.of(context, rootNavigator: true).pop();
      }, true, true);
    }
  }
}
