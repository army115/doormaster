// ignore_for_file: must_be_immutable

import 'package:doormster/components/button/button_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Logo_Opacity extends StatelessWidget {
  String title;
  Logo_Opacity({Key? key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Obx(
      () => Opacity(
        opacity: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                  themeController.isDarkMode == true
                      ? 'assets/images/Smart Logo White.png'
                      : 'assets/images/Smart Community Logo.png',
                  scale: 5),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
