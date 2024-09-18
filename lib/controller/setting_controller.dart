import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/controller/logout_controller.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SettingController settingController = Get.put(SettingController());

class SettingController extends GetxController {
  var uuId;
  var security;
  var language;
  var theme;
  RxBool loading = false.obs;

  @override
  void onInit() async {
    await getValueShared();
    super.onInit();
  }

  Future getValueShared() async {
    final prefs = await SharedPreferences.getInstance();
    uuId = prefs.getString('uuId');
    security = prefs.getBool('security');
    language = prefs.getString('language');
    theme = prefs.getBool('theme');
  }

  Future blockUser() async {
    try {
      loading.value = true;

      var url = '${IP_Address.old_IP}blockUser';
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
        dialogOnebutton_Subtitle(
            title: 'deactivation_fail'.tr,
            subtitle: 'again_pls'.tr,
            icon: Icons.highlight_off_rounded,
            colorIcon: Colors.red,
            textButton: 'ok'.tr,
            press: () {
              Get.back();
            },
            click: false,
            backBtn: false,
            willpop: false);
        print('checkIn not Success!!');
        print(response.data);
      }
    } on DioError catch (e) {
      print(e);
      error_Connected(() {
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
