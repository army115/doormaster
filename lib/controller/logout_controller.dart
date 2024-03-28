import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/controller/login_controller.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LogoutController logoutController = Get.put(LogoutController());

class LogoutController extends GetxController {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final security = prefs.getBool('security');
    //ลบ token device notify
    await Notify_Token().deletenotifyToken();
    //เรียก keys ที่แชร์ไว้มารวมกัน ใน allKeys
    Set<String> allKeys = prefs.getKeys();

    //loop keys เพื่อหา key ที่ไม่ต้องการ remove
    // for (String key in allKeys) {
    //   if (key != 'notifyToken' &&
    //       key != 'security' &&
    //       key != 'language' &&
    //       key != 'theme') {
    //     prefs.remove(key);
    //   }
    // }

    // if (security == true) {
    //   Get.offAll(() => Login_Staff());
    // } else {
    //   Get.offAll(() => Login_Page());
    // }

    if (security == true) {
      for (String key in allKeys) {
        if (key != 'notifyToken' && key != 'language' && key != 'theme') {
          prefs.remove(key);
        }
      }
      log(allKeys.toString());
      Get.offAll(() => Login_Staff());
    } else {
      prefs.remove('token');
      prefs.remove('role');
      prefs.remove('deviceId');
      prefs.remove('weiganId');
      prefs.remove('security');
      prefs.remove('image');
      prefs.remove('fname');
      prefs.remove('lname');
      log(allKeys.toString());
      Get.offAll(() => Login_Page());
    }
    loginController.loadUsernamePassword();
    print('logout success');
  }
}
