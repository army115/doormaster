import 'dart:developer';

import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/test_chat/auth_service.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final LogoutController logoutController = LogoutController();

class LogoutController {
  Future<void> logout() async {
    try {
      //ลบ token device notify
      // await Notify_Token().deletenotifyToken();
      // await AuthService().signout();
      //เรียก keys ที่แชร์ไว้มารวมกัน ใน allKeys
      Set<String> allKeys = await SecureStorageUtils.getAllKeys();
      log("allKeys: $allKeys");

      //loop keys เพื่อหา key ที่ไม่ต้องการ remove
      for (String key in allKeys) {
        if (key != 'username' &&
            key != 'password' &&
            key != 'language' &&
            key != 'remember' &&
            key != 'notifyToken' &&
            key != 'theme') {
          SecureStorageUtils.delete(key);
        }
      }

      Get.offAll(() => Login_Page());
    } catch (e) {
      debugPrint('Logout failed: $e');
      Get.snackbar('Error', 'Failed to logout. Please try again.');
    }
  }
}
