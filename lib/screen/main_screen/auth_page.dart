import 'package:doormster/components/button/button_language.dart';
import 'package:doormster/components/button/button_theme.dart';
import 'package:doormster/components/snackbar/back_double.dart';
import 'package:doormster/controller/back_double.dart';
import 'package:doormster/service/notify/notify_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth_Page extends StatefulWidget {
  Auth_Page({Key? key});

  @override
  State<Auth_Page> createState() => _Auth_PageState();
}

class _Auth_PageState extends State<Auth_Page> {
  DateTime pressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onBackDoubleClicked(context, pressTime),
      child: Scaffold(
        backgroundColor: Get.theme.primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Smart Logo White.png',
                          // scale: 3,
                          height: Get.mediaQuery.size.height * 0.4,
                        ),
                        GridView.count(
                          crossAxisCount: 2,
                          primary: false,
                          // maxCrossAxisExtent: 300,
                          crossAxisSpacing: 20,
                          shrinkWrap: true,
                          children: [
                            menuButton('user'.tr, Icons.person, () {
                              Navigator.pushReplacementNamed(context, '/login');
                            }),
                            menuButton(
                                'employee'.tr, Icons.manage_accounts_rounded,
                                () {
                              Navigator.pushReplacementNamed(context, '/staff');
                            })
                          ],
                        ),
                      ]),
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: button_language(Colors.white, Get.theme.primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuButton(
    title,
    icon,
    press,
  ) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        onTap: press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Get.theme.primaryColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
