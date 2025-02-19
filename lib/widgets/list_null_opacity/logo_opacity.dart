// ignore_for_file: must_be_immutable

import 'package:doormster/controller/theme_controller.dart';
import 'package:doormster/widgets/button/button_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Logo_Opacity extends StatelessWidget {
  String title;
  Logo_Opacity({super.key, required this.title});

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
              themeController.imageTheme(
                  imageLight: 'assets/images/HIP_Smart_Community_Logo.png',
                  imageDark: 'assets/images/HIP_Smart_Community_Logo_White.png',
                  scale: 5.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
