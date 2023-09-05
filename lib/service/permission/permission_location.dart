import 'dart:io';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> permissionLocation(context, action) async {
  final permission = await Permission.location.request();
  final location = await Geolocator.isLocationServiceEnabled();
  print(permission);
  print("location : $location");

  if (Platform.isAndroid) {
    print('divices : android');
    if (permission.isGranted) {
      await action();
    } else {
      dialogOnebutton_Subtitle(
          context,
          'allow_access'.tr,
          'need_access_location'.tr,
          Icons.warning_amber_rounded,
          Colors.orange,
          'ok'.tr, () {
        openAppSettings();

        Navigator.of(context, rootNavigator: true).pop();
      }, true, true);
    }
  } else if (Platform.isIOS) {
    print("divices : apple");
    if (permission.isGranted && location) {
      await action();
    } else if (!location) {
      dialogOnebutton_Subtitle(
          context,
          'access_location'.tr,
          'turn_on_location'.tr,
          Icons.warning_amber_rounded,
          Colors.orange,
          'ok'.tr, () async {
        await launch('App-Prefs:LOCATION_SERVICES');

        Navigator.of(context, rootNavigator: true).pop();
      }, true, true);
    } else {
      dialogOnebutton_Subtitle(
          context,
          'allow_access'.tr,
          'need_access_location'.tr,
          Icons.warning_amber_rounded,
          Colors.orange,
          'ok'.tr, () {
        print('setting');
        openAppSettings();

        Navigator.of(context, rootNavigator: true).pop();
      }, true, true);
    }
  }
}
