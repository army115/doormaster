// ignore_for_file: non_constant_identifier_names

import 'package:doormster/widgets/button/button_close.dart';
import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogOnebutton_Subtitle({
  required title,
  required subtitle,
  required icon,
  required colorIcon,
  required textButton,
  required press,
  required backBtn,
  required click,
  required willpop,
}) {
  Get.dialog(
      transitionDuration: Duration.zero,
      barrierDismissible: click,
      WillPopScope(
        onWillPop: (() async => willpop),
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              iconPadding: EdgeInsets.zero,
              titlePadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              icon: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Icon(
                      icon,
                      size: 60,
                      color: colorIcon,
                    ),
                  ),
                  backBtn
                      ? closeButton(
                          radius: 15,
                          onPress: () {
                            Get.back();
                          })
                      : Container()
                ],
              ),
              title: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              actions: [
                SizedBox(
                  width: Get.mediaQuery.size.width,
                  child: ElevatedButton(
                    style: styleButtons(const EdgeInsets.symmetric(vertical: 5),
                        10.0, Get.theme.primaryColor, BorderRadius.circular(5)),
                    onPressed: press,
                    child: Text(
                      textButton,
                      style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}

Widget dialogmain(title, subtitle, icon, coloricon, button, press) {
  return AlertDialog(
    iconPadding: EdgeInsets.zero,
    titlePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
    contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    icon: Icon(
      icon,
      size: 60,
      color: coloricon,
    ),
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    content: Text(
      subtitle,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 16),
    ),
    actionsPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    actions: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: styleButtons(const EdgeInsets.symmetric(vertical: 5), 10.0,
              Get.theme.primaryColor, BorderRadius.circular(5)),
          onPressed: press,
          child: Text(
            button,
            style: const TextStyle(
                fontSize: 16,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ],
  );
}
