import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget textDoubleColorsIcon(
    {required text1,
    Color? color1,
    required text2,
    required Icon icon,
    Color? color2,
    double? fontsize1,
    double? fontsize2,
    FontWeight? fontWeight1,
    FontWeight? fontWeight2,
    TextOverflow? overflow}) {
  return Text.rich(
    overflow: overflow,
    TextSpan(
      children: [
        WidgetSpan(
            child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: icon,
        )),
        TextSpan(
          text: text1,
          style: TextStyle(
              color: color1 ?? Get.theme.dividerColor,
              fontSize: fontsize1,
              fontWeight: fontWeight1),
        ),
        TextSpan(
            text: text2,
            style: TextStyle(
                color: color2 ?? Get.theme.dividerColor,
                fontSize: fontsize2,
                fontWeight: fontWeight2)),
      ],
    ),
  );
}
