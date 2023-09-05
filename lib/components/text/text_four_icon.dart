import 'package:flutter/material.dart';

Widget textFourIcon(text1, text2, text3, text4,
    {Icon? icon,
    Color? color1,
    Color? color2,
    Color? color3,
    Color? color4,
    double? fontsize1,
    double? fontsize2,
    double? fontsize3,
    double? fontsize4,
    TextOverflow? overflow}) {
  return Row(
    children: [
      Padding(
        padding:
            icon == null ? EdgeInsets.zero : const EdgeInsets.only(right: 5),
        child: icon,
      ),
      Expanded(
        child: Text.rich(
          overflow: overflow,
          TextSpan(
            text: text1,
            style: TextStyle(color: color1, fontSize: fontsize1),
            children: [
              TextSpan(
                  text: text2,
                  style: TextStyle(color: color2, fontSize: fontsize2),
                  children: [
                    TextSpan(
                        text: text3,
                        style: TextStyle(color: color3, fontSize: fontsize3),
                        children: [
                          TextSpan(
                            text: text4,
                            style:
                                TextStyle(color: color4, fontSize: fontsize4),
                          )
                        ])
                  ]),
            ],
          ),
        ),
      ),
    ],
  );
}
