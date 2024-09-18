import 'dart:io';

import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> permissionPhotos(context, action) async {
  final permission = await Permission.photos.request();
  print(permission);
  if (permission.isGranted || permission.isLimited) {
    action;
  } else {
    dialogOnebutton_Subtitle(
        title: 'allow_access'.tr,
        subtitle: 'need_access_picture'.tr,
        icon: Icons.warning_amber_rounded,
        colorIcon: Colors.orange,
        textButton: 'ok'.tr,
        press: () {
          Navigator.of(context, rootNavigator: true).pop();
          openAppSettings();
        },
        click: true,
        backBtn: true,
        willpop: true);
  }
}

Future<void> permissionAddPhotos(context, action) async {
  final permission = await Permission.photosAddOnly.request();
  print(permission);
  if (Platform.isIOS) {
    if (permission.isGranted || permission.isLimited) {
      await action();
    } else {
      dialogOnebutton_Subtitle(
          title: 'allow_access'.tr,
          subtitle: 'need_access_picture'.tr,
          icon: Icons.warning_amber_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () {
            Navigator.of(context, rootNavigator: true).pop();
            openAppSettings();
          },
          click: true,
          backBtn: true,
          willpop: true);
    }
  } else {
    await action();
  }
}
