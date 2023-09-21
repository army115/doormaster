// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:doormster/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Settings_Page extends StatefulWidget {
  const Settings_Page({super.key});

  @override
  State<Settings_Page> createState() => _Settings_PageState();
}

class menuItem {
  IconData icon;
  String title;
  VoidCallback ontap;
  Color color;
  menuItem(this.icon, this.title, this.ontap, this.color);
}

class _Settings_PageState extends State<Settings_Page> {
  late SharedPreferences prefs;
  var uuId;
  var security;
  var language;
  bool loading = false;
  PackageInfo? packageInfo;

  Future getValueShared() async {
    final info = await PackageInfo.fromPlatform();
    prefs = await SharedPreferences.getInstance();
    uuId = prefs.getString('uuId');
    security = prefs.getBool('security');
    language = prefs.getString('language');
    print('uuId: ${uuId}');
    setState(() {
      packageInfo = info;
    });
  }

  Future<void> _Logout() async {
    //ลบ token device notify
    await Notify_Token().deletenotifyToken();
    Set<String> allKeys = prefs.getKeys();

    for (String key in allKeys) {
      if (key != 'notifyToken' && key != 'security') {
        prefs.remove(key);
      }
    }

    log(allKeys.toString());
    if (security == true) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login_Staff()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
          (Route<dynamic> route) => false);
    }
    print('logout success');
  }

  Future _blockUser() async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/blockUser';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: {"uuid": uuId, "Block": 1});
      var _response = response.toString().split(',').first.split(':').last;
      print(_response);
      if (_response == '200') {
        print('block Success');
        print(response.data);

        _Logout();

        snackbar(context, Theme.of(context).primaryColor,
            'deactivation_success'.tr, Icons.check_circle_outline_rounded);

        setState(() {
          loading = false;
        });
      } else {
        dialogOnebutton_Subtitle(
            context,
            'deactivation_fail'.tr,
            'again_pls'.tr,
            Icons.highlight_off_rounded,
            Colors.red,
            'ok'.tr, () {
          Navigator.of(context, rootNavigator: true).pop();
        }, false, false);
        print('checkIn not Success!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      error_connected(context, () {
        Navigator.of(context, rootNavigator: true).pop();
      });
      setState(() {
        loading = false;
      });
    }
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 3, color: Theme.of(context).primaryColor),
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
                  Expanded(
                    child: Column(children: [
                      ListTile(
                        selectedTileColor: language == 'th'
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        selected: language == 'th' ? true : false,
                        title: Text(
                          'ไทย',
                          style: TextStyle(
                              color: language == 'th'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        onTap: () async {
                          if (language == 'th') {
                            Get.back();
                          } else {
                            bottomController.ontapItem(0);
                            Get.until((route) => route.isFirst);
                            Get.updateLocale(Locale('th'));
                            await prefs.setString("language", 'th');
                          }
                        },
                      ),
                      ListTile(
                        selectedTileColor: language == 'en'
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        selected: language == 'en' ? true : false,
                        title: Text(
                          'English',
                          style: TextStyle(
                              color: language == 'en'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        onTap: () async {
                          if (language == 'en') {
                            Get.back();
                          } else {
                            bottomController.ontapItem(0);
                            Get.until((route) => route.isFirst);
                            Get.updateLocale(Locale('en'));
                            await prefs.setString("language", 'en');
                          }
                        },
                      ),
                    ]),
                  ),
                ]),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    getValueShared();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<menuItem> _menu = [
      menuItem(Icons.lock, 'change_password'.tr, () {
        Get.toNamed('/password');
      }, Colors.black),
      menuItem(Icons.translate_rounded, 'change_language'.tr, () {
        _openBottomSheet(context);
      }, Colors.black),
      menuItem(Icons.no_accounts_rounded, 'disable_account'.tr, () {
        dialogTwobutton_Subtitle(
            context,
            'disable_account'.tr,
            'deactivate_confirm'.tr,
            Icons.warning_amber_rounded,
            Colors.orange,
            'no'.tr,
            () {
              Navigator.pop(context);
            },
            'yes'.tr,
            () {
              _blockUser();
            },
            true,
            true);
      }, Colors.red),
      menuItem(
          Icons.app_settings_alt_rounded,
          '${'version'.tr} ${packageInfo?.version}',
          () {},
          Colors.grey.shade600)
    ];
    return Scaffold(
      appBar: AppBar(title: Text('setting'.tr)),
      body: Container(
        child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          itemCount: _menu.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: _menu[index].ontap,
              leading: Icon(
                _menu[index].icon,
                size: 30,
                color: Colors.grey.shade700,
              ),
              title: Text(
                _menu[index].title,
                style: TextStyle(
                    letterSpacing: 0.5,
                    color: _menu[index].color,
                    fontSize: 16),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Colors.black,
              height: 10,
            );
          },
        ),
      ),
    );
  }
}
