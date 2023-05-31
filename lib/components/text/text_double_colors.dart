import 'package:flutter/material.dart';

Widget textDoubleColors(text1, color1, text2, color2) {
  return Text.rich(
    TextSpan(
      text: text1,
      style: TextStyle(color: color1),
      children: [
        TextSpan(text: text2, style: TextStyle(color: color2)),
      ],
    ),
  );
}
