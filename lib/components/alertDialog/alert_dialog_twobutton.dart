import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogTwobutton(
  title,
  icon,
  coloricon,
  button1,
  press1,
  button2,
  press2,
  click,
  willpop,
) {
  Get.dialog(
      transitionDuration: Duration.zero,
      barrierDismissible: click,
      WillPopScope(
        onWillPop: () async => willpop,
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
                    width: Get.mediaQuery.size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: styleButtons(
                              EdgeInsets.symmetric(vertical: 5, horizontal: 35),
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
                        ElevatedButton(
                          style: styleButtons(
                              EdgeInsets.symmetric(vertical: 5, horizontal: 25),
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
}
