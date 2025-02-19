// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogTwobutton_Subtitle({
  required title,
  required subtitle,
  required icon,
  required colorIcon,
  required textButton1,
  required press1,
  required textButton2,
  required press2,
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
              iconPadding: EdgeInsets.symmetric(vertical: 10),
              titlePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              icon: Icon(
                icon,
                size: 60,
                color: colorIcon,
              ),
              title: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    style: styleButtons(EdgeInsets.symmetric(vertical: 5), 10.0,
                        Get.theme.primaryColor, BorderRadius.circular(5)),
                    child: Text(
                      textButton1,
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: press1,
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    style: styleButtons(EdgeInsets.symmetric(vertical: 5), 10.0,
                        Get.theme.primaryColor, BorderRadius.circular(5)),
                    child: Text(
                      textButton2,
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: press2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}
