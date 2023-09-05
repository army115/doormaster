import 'package:flutter/material.dart';

Widget textDoubleColors(text1, color1, text2, color2,
    {double? fontsize, TextOverflow? overflow}) {
  return Text.rich(
    overflow: overflow,
    TextSpan(
      text: text1,
      style: TextStyle(color: color1, fontSize: fontsize),
      children: [
        TextSpan(
            text: text2, style: TextStyle(color: color2, fontSize: fontsize)),
      ],
    ),
  );
}
