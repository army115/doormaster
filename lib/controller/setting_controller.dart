import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/controller/logout_controller.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SettingController settingController = Get.put(SettingController());

class SettingController extends GetxController {
  var uuId;
  var security;
  var language;
  var theme;
  RxBool loading = false.obs;
  RxString version = ''.obs;

  @override
  void onInit() async {
    await getValueShared();
    super.onInit();
  }

  Future getValueShared() async {
    final info = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    uuId = prefs.getString('uuId');
    security = prefs.getBool('security');
    language = prefs.getString('language') ?? 'th';
    theme = prefs.getBool('theme');
    version.value = info.version;
  }

  Future blockUser() async {
    try {
      loading.value = true;

      var url = '${Connect_api().domain}/blockUser';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: {"uuid": uuId, "Block": 1});
      var _response = response.data['status'];
      print("status code : ${_response}");
      if (_response == 200) {
        print('block Success');
        print(response.data);

        logoutController.logout();

        snackbar(Get.theme.primaryColor, 'deactivation_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        dialogOnebutton_Subtitle('deactivation_fail'.tr, 'again_pls'.tr,
            Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
          Get.back();
        }, false, false);
        print('checkIn not Success!!');
        print(response.data);
      }
    } on DioError catch (e) {
      print(e);
      error_connected(() {
        Get.back();
      });
    } finally {
      loading.value = false;
    }
  }

  void setLangauge(Language) async {
    final prefs = await SharedPreferences.getInstance();
    if (Language != language) {
      bottomController.ontapItem(0);
      Get.until((route) => route.isFirst);
      Get.updateLocale(Locale(Language));
      await prefs.setString("language", Language);
      settingController.getValueShared();
    } else {
      Get.back();
    }
  }
}
