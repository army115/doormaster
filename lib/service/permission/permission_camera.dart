import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> permissionCamere(context, action) async {
  final permission = await Permission.camera.request();
  debugPrint(permission.toString());
  if (permission.isGranted) {
    await action();
  } else {
    dialogOnebutton_Subtitle(
        title: 'allow_access'.tr,
        subtitle: 'need_access_camera'.tr,
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
}
