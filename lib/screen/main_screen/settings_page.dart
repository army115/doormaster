// ignore_for_file: unused_field, use_build_context_synchronously, non_constant_identifier_names

import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/button/button_theme.dart';
import 'package:doormster/controller/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings_Page extends StatefulWidget {
  const Settings_Page({super.key});

  @override
  State<Settings_Page> createState() => _Settings_PageState();
}

class _Settings_PageState extends State<Settings_Page> {
  List languageManu = ['ไทย', 'English'];
  List languageLocal = ['th', 'en'];
  String? version = '';

  Future getVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  @override
  void initState() {
    getVersion();
    super.initState();
  }

  void _changeLanguage(BuildContext context) {
    print(settingController.language);
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 3, color: Get.theme.primaryColor),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.3,
          minChildSize: 0.2,
          maxChildSize: 0.5,
          builder: (context, scrollController) => Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'select_language'.tr,
                      style: textStyle().Header18,
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Get.theme.primaryColor,
                    thickness: 1.5,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: languageManu.length,
                    itemBuilder: (context, index) => ListTile(
                      selectedTileColor:
                          settingController.language == languageLocal[index]
                              ? Get.theme.primaryColor
                              : Colors.white,
                      selected:
                          settingController.language == languageLocal[index]
                              ? true
                              : false,
                      title: Text(
                        languageManu[index],
                        style: TextStyle(
                            color: settingController.language ==
                                    languageLocal[index]
                                ? Colors.white
                                : Colors.black),
                      ),
                      onTap: () async {
                        settingController.setLangauge(languageLocal[index]);
                      },
                    ),
                  )),
                ]),
          ),
        );
      },
    );
  }

  List themetitle = ['light'.tr, 'dark'.tr, 'system'.tr];
  List themeMenu = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
  List themeStatus = [false, true, null];

  void _changeTheme(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 3, color: Get.theme.primaryColor),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.4,
          minChildSize: 0.3,
          maxChildSize: 0.5,
          builder: (context, scrollController) => Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      'select_theme'.tr,
                      style: textStyle().Header18,
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Get.theme.primaryColor,
                    thickness: 1.5,
                  ),
                  Expanded(
                      child: ListView.builder(
                    itemCount: themeMenu.length,
                    itemBuilder: (context, index) => ListTile(
                      selectedTileColor:
                          settingController.theme == themeStatus[index]
                              ? Get.theme.primaryColor
                              : Colors.white,
                      selected: settingController.theme == themeStatus[index]
                          ? true
                          : false,
                      title: Text(
                        themetitle[index],
                        style: TextStyle(
                            color: settingController.theme == themeStatus[index]
                                ? Colors.white
                                : Colors.black),
                      ),
                      onTap: () async {
                        setThemeMode(themeMenu[index]);
                        settingController.getValueShared();
                        Get.back();
                      },
                    ),
                  )),
                ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<menuItem> menu = [
      menuItem(Icons.lock, 'change_password'.tr, () {
        Get.toNamed('/password');
      }, Get.theme.dividerColor),
      menuItem(Icons.translate_rounded, 'change_language'.tr, () {
        _changeLanguage(context);
      }, Get.theme.dividerColor),
      menuItem(Icons.brightness_4, 'change_theme'.tr, () {
        _changeTheme(context);
      }, Get.theme.dividerColor),
      menuItem(Icons.no_accounts_rounded, 'disable_account'.tr, () {
        dialogTwobutton_Subtitle(
            'disable_account'.tr,
            'deactivate_confirm'.tr,
            Icons.warning_amber_rounded,
            Colors.orange,
            'no'.tr,
            () {
              Get.back();
            },
            'yes'.tr,
            () {
              settingController.blockUser();
              Get.back();
            },
            true,
            true);
      }, Colors.redAccent.shade400),
      menuItem(Icons.app_settings_alt_rounded, '${'version'.tr} ${version}',
          () {}, Get.theme.dividerColor.withOpacity(0.5))
    ].obs;
    return Scaffold(
        appBar: AppBar(title: Text('setting'.tr)),
        body: Obx(() => ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: menu[index].ontap,
                    leading: Icon(
                      menu[index].icon,
                      size: 30,
                      color: Get.theme.dividerColor.withOpacity(0.7),
                    ),
                    title: Text(
                      menu[index].title,
                      style: TextStyle(
                          letterSpacing: 0.5,
                          color: menu[index].color,
                          fontSize: 16),
                    ));
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Get.theme.dividerColor,
                  height: 10,
                );
              },
            )));
  }
}

class menuItem {
  IconData icon;
  String title;
  VoidCallback ontap;
  Color color;
  menuItem(this.icon, this.title, this.ontap, this.color);
}
