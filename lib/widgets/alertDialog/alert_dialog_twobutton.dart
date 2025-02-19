import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialogTwobutton({
  required title,
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
        onWillPop: () async => willpop,
        child: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
                iconPadding: const EdgeInsets.symmetric(vertical: 10),
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
                title: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [
                  ElevatedButton(
                    style: styleButtons(
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 35),
                        10.0,
                        Get.theme.primaryColor,
                        BorderRadius.circular(5)),
                    onPressed: press1,
                    child: Text(
                      textButton1,
                      style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    style: styleButtons(
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                        10.0,
                        Get.theme.primaryColor,
                        BorderRadius.circular(5)),
                    onPressed: press2,
                    child: Text(
                      textButton2,
                      style: const TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
          ),
        ),
      ));
}
