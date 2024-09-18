import 'package:doormster/controller/login_controller.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final LogoutController logoutController = LogoutController();

class LogoutController {
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      //ลบ token device notify
      // await Notify_Token().deletenotifyToken();
      //เรียก keys ที่แชร์ไว้มารวมกัน ใน allKeys
      Set<String> allKeys = prefs.getKeys();

      //loop keys เพื่อหา key ที่ไม่ต้องการ remove
      for (String key in allKeys) {
        if (key != 'username' &&
            key != 'password' &&
            key != 'language' &&
            key != 'remember' &&
            key != 'theme') {
          prefs.remove(key);
        }
      }
      Get.offAll(() => Login_Page());

      // if (security == true) {
      //   for (String key in allKeys) {
      //     if (key != 'notifyToken' &&
      //         key != 'language' &&
      //         key != 'theme' &&
      //         key != 'remember' &&
      //         key != 'security') {
      //       prefs.remove(key);
      //     }
      //   }
      //   Get.offAll(() => Login_Staff());
      // } else {
      //   prefs.remove('token');
      //   prefs.remove('deviceId');
      //   prefs.remove('weiganId');
      //   prefs.remove('role');
      //   prefs.remove('image');
      //   prefs.remove('fname');
      //   prefs.remove('lname');
      //   Get.offAll(() => Login_Page());
      // }
    } catch (e) {
      print('Logout failed: $e');
      Get.snackbar('Error', 'Failed to logout. Please try again.');
    }
  }
}
