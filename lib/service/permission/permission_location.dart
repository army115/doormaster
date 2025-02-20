import 'dart:io';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> permissionLocation(context, action) async {
  final permission = await Permission.location.request();
  final location = await Geolocator.isLocationServiceEnabled();
  debugPrint(permission.toString());
  debugPrint("location : $location");

  if (Platform.isAndroid) {
    if (permission.isGranted) {
      await action();
    } else {
      dialogOnebutton_Subtitle(
          title: 'allow_access'.tr,
          subtitle: 'need_access_location'.tr,
          icon: Icons.warning_amber_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () {
            openAppSettings();
            Get.back();
          },
          click: true,
          backBtn: true,
          willpop: true);
    }
  } else if (Platform.isIOS) {
    if (permission.isGranted && location) {
      await action();
    } else if (!location) {
      dialogOnebutton_Subtitle(
          title: 'access_location'.tr,
          subtitle: 'turn_on_location'.tr,
          icon: Icons.warning_amber_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () async {
            await launch('App-Prefs:LOCATION_SERVICES');

            Get.back();
          },
          click: true,
          backBtn: true,
          willpop: true);
    } else {
      dialogOnebutton_Subtitle(
          title: 'allow_access'.tr,
          subtitle: 'need_access_location'.tr,
          icon: Icons.warning_amber_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () {
            debugPrint('setting');
            openAppSettings();

            Get.back();
          },
          click: true,
          backBtn: true,
          willpop: true);
    }
  }
}
