// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace

import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogOnebutton({
  required title,
  required icon,
  required colorIcon,
  required textButton,
  required press,
  required click,
  required willpop,
}) {
  Get.dialog(
      transitionDuration: Duration.zero,
      barrierDismissible: click,
      WillPopScope(
        onWillPop: () async => willpop,
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              iconPadding: EdgeInsets.symmetric(vertical: 10),
              titlePadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              icon: Icon(
                icon,
                size: 60,
                color: colorIcon,
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              actions: [
                Container(
                  width: Get.mediaQuery.size.width,
                  child: ElevatedButton(
                    style: styleButtons(
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        10.0,
                        Get.theme.primaryColor,
                        BorderRadius.circular(5)),
                    child: Text(
                      textButton,
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: press,
                  ),
                ),
              ],
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
      ));
}
