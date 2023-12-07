// ignore_for_file: prefer_const_constructors, sort_child_properties_last, sized_box_for_whitespace

import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogOnebutton(
  context,
  title,
  icon,
  coloricon,
  button,
  press,
  click,
  willpop,
) {
  showDialog(
      useRootNavigator: true,
      barrierDismissible: click,
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: () async => willpop,
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
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          style: styleButtons(
                              EdgeInsets.symmetric(vertical: 5),
                              10.0,
                              Get.theme.primaryColor,
                              BorderRadius.circular(5)),
                          child: Text(
                            button,
                            style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 1,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: press,
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
