import 'package:doormster/components/button/button_close.dart';
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
              titlePadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Column(
                      children: [
                        Icon(
                          icon,
                          size: 60,
                          color: colorIcon,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: Get.mediaQuery.size.width,
                          child: ElevatedButton(
                            style: styleButtons(
                                const EdgeInsets.symmetric(vertical: 5),
                                10.0,
                                Get.theme.primaryColor,
                                BorderRadius.circular(5)),
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
                        const SizedBox(
                          height: 5,
                        ),
                      ],
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
            ),
          ),
        ),
      ));
}

Widget dialogmain(title, subtitle, icon, coloricon, button, press) {
  return AlertDialog(
    titlePadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 10,
        ),
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
        const SizedBox(
          height: 5,
        ),
      ],
    ),
  );
}
