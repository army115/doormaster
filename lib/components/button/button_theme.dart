// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Buttontheme themeController = Get.put(Buttontheme());

class Buttontheme extends GetxController {
  RxBool isDarkMode = false.obs;
  var theme;

  @override
  void onInit() async {
    loadTheme();
    super.onInit();
  }

  void loadTheme() async {
    final brightness = Get.mediaQuery.platformBrightness;
    final prefs = await SharedPreferences.getInstance();
    final darkModeOn = (brightness == Brightness.dark);
    // print("darkModeOn: $darkModeOn");
    theme = prefs.get('theme');
    // print("theme :$theme");
    if (theme != null) {
      isDarkMode.value = theme;
    } else {
      isDarkMode.value = darkModeOn;
    }
  }

  void changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = !isDarkMode.value;
    if (!isDarkMode.value) {
      Get.changeThemeMode(ThemeMode.light);
      await prefs.setBool("theme", false);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      await prefs.setBool("theme", true);
    }
  }

  Widget button_theme(colorCard, colorIcon) => Card(
      color: colorCard,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: InkWell(
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            isDarkMode.value
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            size: 30,
            color: colorIcon,
          ),
        ),
        onTap: changeTheme,
      ));

  Widget imageTheme({scale, height, width}) {
    themeController.loadTheme();
    return Image.asset(
      isDarkMode.isTrue
          ? 'assets/images/Smart Logo White.png'
          : 'assets/images/Smart Community Logo.png',
      scale: scale,
      height: height,
      width: width,
    );
  }
}

void setThemeMode(mode) async {
  bool darkModeOn = (mode == ThemeMode.dark);
  final prefs = await SharedPreferences.getInstance();
  Get.changeThemeMode(mode);
  if (mode == ThemeMode.system) {
    await prefs.remove("theme");
  } else {
    await prefs.setBool("theme", darkModeOn);
  }
  themeController.loadTheme();
}

Widget button_theme(colorCard, colorIcon) => Card(
    color: colorCard,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        constraints: BoxConstraints(maxWidth: Get.mediaQuery.size.width * 0.2),
        position: PopupMenuPosition.under,
        elevation: 3,
        icon: Icon(Icons.settings_outlined, size: 30, color: colorIcon),
        onSelected: (value) => setThemeMode(value),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: ThemeMode.light,
                child: Center(child: Text('ปิด')),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Center(child: Text('เปิด')),
              ),
              PopupMenuItem(
                value: ThemeMode.system,
                child: Center(child: Text('ระบบ')),
              ),
            ]));
