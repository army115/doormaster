import 'dart:io';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> permissionLocation(context, action) async {
  final permission = await Permission.location.request();
  final location = await Geolocator.isLocationServiceEnabled();
  print(permission);
  print("location : $location");
  if (permission.isGranted && location) {
    await action();
  } else {
    dialogOnebutton_Subtitle(
        context,
        'อนุญาตการเข้าถึง',
        'จำเป็นต้องเข้าถึงตำแหน่งอุปกรณ์ของคุณ',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง', () async {
      if (!location) {
        if (Platform.isAndroid) {
          print('android');
          AppSettings.openLocationSettings();
        } else if (Platform.isIOS) {
          print("apple");
          await launch('App-Prefs:LOCATION_SERVICES');
        }
      } else {
        print('setting');
        AppSettings.openAppSettings();
      }

      Navigator.of(context, rootNavigator: true).pop();
    }, true, true);
  }
}
