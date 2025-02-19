import 'package:doormster/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ThemeController themeController = Get.put(ThemeController());

class ThemeController extends GetxController with WidgetsBindingObserver {
  Rxn<ThemeMode> themeMode = Rxn<ThemeMode>();
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    loadTheme();
  }

  void loadTheme() async {
    bool? theme = await SecureStorageUtils.readBool('theme');
    if (theme == null) {
      themeMode.value = ThemeMode.system;
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = (brightness == Brightness.dark);
    } else if (theme == true) {
      themeMode.value = ThemeMode.dark;
      isDarkMode.value = true;
    } else {
      themeMode.value = ThemeMode.light;
      isDarkMode.value = false;
    }
  }

  void setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    if (mode == ThemeMode.system) {
      await SecureStorageUtils.delete("theme");
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = (brightness == Brightness.dark);
    } else if (mode == ThemeMode.dark) {
      await SecureStorageUtils.writeBool("theme", true);
      isDarkMode.value = true;
    } else {
      await SecureStorageUtils.writeBool("theme", false);
      isDarkMode.value = false;
    }
    Get.changeThemeMode(mode);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (themeMode.value == ThemeMode.system) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = (brightness == Brightness.dark);
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  Widget imageTheme(
      {required String imageLight,
      required String imageDark,
      double? scale,
      double? height,
      double? width,
      BoxFit? BoxFit}) {
    return Image.asset(
      isDarkMode.isTrue ? imageDark : imageLight,
      scale: scale,
      height: height,
      width: width,
      fit: BoxFit,
    );
  }
}
