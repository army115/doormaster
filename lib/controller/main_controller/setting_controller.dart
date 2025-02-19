import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/bottombar/bottom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingController extends GetxController {
  String? language;
  bool? theme;
  RxString version = ''.obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    getValueShared();
    super.onInit();
  }

  Future getValueShared() async {
    language = await SecureStorageUtils.readString('language');
    theme = await SecureStorageUtils.readBool('theme');
    final info = await PackageInfo.fromPlatform();
    version.value = info.version;
  }

  void setLangauge(Language) async {
    if (Language != language) {
      bottomController.ontapItem(0);
      Get.until((route) => route.isFirst);
      Get.updateLocale(Locale(Language));
      await SecureStorageUtils.writeString("language", Language);
      getValueShared();
    } else {
      Get.back();
    }
  }
}
