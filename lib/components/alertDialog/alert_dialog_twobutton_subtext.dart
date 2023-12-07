// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogTwobutton_Subtitle(
  context,
  title,
  subtitle,
  icon,
  coloricon,
  button1,
  press1,
  button2,
  press2,
  click,
  willpop,
) {
  showDialog(
      useRootNavigator: true,
      barrierDismissible: click,
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: (() async => willpop),
            child: Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  titlePadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Column(
                    children: [
                      Icon(
                        icon,
                        size: 60,
                        color: coloricon,
                      ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                        // width: MediaQuery.of(context).size.width,
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
                                  button1,
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
                                  button2,
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
