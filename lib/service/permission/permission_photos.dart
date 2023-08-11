import 'dart:io';

import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> permissionPhotos(context, action) async {
  final permission = await Permission.photos.request();
  print(permission);
  if (permission.isGranted || permission.isLimited) {
    action;
  } else {
    dialogOnebutton_Subtitle(
        context,
        'อนุญาตการเข้าถึง',
        'จำเป็นต้องเข้าถึงรูปภาพของคุณ',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง', () {
      Navigator.of(context, rootNavigator: true).pop();
      openAppSettings();
    }, true, true);
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
          context,
          'อนุญาตการเข้าถึง',
          'จำเป็นต้องเข้าถึงรูปภาพของคุณ',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.of(context, rootNavigator: true).pop();
        openAppSettings();
      }, true, true);
    }
  } else {
    await action();
  }
}
