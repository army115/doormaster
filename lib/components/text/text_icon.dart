import 'package:flutter/material.dart';

Widget textIcon(text, icon, {Color? color}) {
  return Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
            child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: icon,
        )),
        TextSpan(text: text, style: TextStyle(color: color)),
      ],
    ),
  );
}
