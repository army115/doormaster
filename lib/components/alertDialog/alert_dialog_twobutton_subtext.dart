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
              titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                children: [
                  Icon(
                    icon,
                    size: 60,
                    color: colorIcon,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // width: Get.mediaQuery.size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 90,
                          child: ElevatedButton(
                            style: styleButtons(
                                EdgeInsets.symmetric(vertical: 5),
                                10.0,
                                Get.theme.primaryColor,
                                BorderRadius.circular(5)),
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
                            style: styleButtons(
                                EdgeInsets.symmetric(vertical: 5),
                                10.0,
                                Get.theme.primaryColor,
                                BorderRadius.circular(5)),
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
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}
