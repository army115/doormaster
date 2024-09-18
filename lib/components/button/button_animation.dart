// ignore_for_file: must_be_immutable

import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget Button_Animation({required title, required press}) {
  return EasyButton(
      type: EasyButtonType.elevated,
      idleStateWidget: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          letterSpacing: 1,
        ),
      ),
      loadingStateWidget: const CircularProgressIndicator(
        color: Colors.white,
      ),
      elevation: 10,
      useWidthAnimation: true,
      useEqualLoadingStateWidgetDimension: true,
      width: Get.mediaQuery.size.width * 0.5,
      height: 45,
      borderRadius: 10.0,
      contentGap: 5.0,
      buttonColor: Get.theme.primaryColor,
      onPressed: press);
}
