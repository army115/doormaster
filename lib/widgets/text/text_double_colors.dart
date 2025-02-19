import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textDoubleColors(
    {required text1,
    Color? color1,
    required text2,
    Color? color2,
    double? fontsize,
    TextOverflow? overflow}) {
  return Text.rich(
    overflow: overflow,
    TextSpan(
      text: text1,
      style: TextStyle(
          color: color1 ?? Get.theme.dividerColor, fontSize: fontsize),
      children: [
        TextSpan(
            text: text2,
            style: TextStyle(
                color: color2 ?? Get.theme.dividerColor, fontSize: fontsize)),
      ],
    ),
  );
}
