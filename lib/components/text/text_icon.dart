import 'package:flutter/material.dart';

Widget textIcon(text, icon) {
  return Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
            child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: icon,
        )),
        TextSpan(text: text),
      ],
    ),
  );
}
