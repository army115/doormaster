import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> permissionCamere(context, action) async {
  final permission = await Permission.camera.request();
  print(permission);
  if (permission.isGranted) {
    await action();
  } else {
    dialogOnebutton_Subtitle(
        context,
        'อนุญาตการเข้าถึง',
        'จำเป็นต้องเข้าถึงกล้องของคุณ',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง', () {
      openAppSettings();
      Navigator.of(context, rootNavigator: true).pop();
    }, true, true);
  }
}
