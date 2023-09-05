import 'package:flutter/material.dart';

Widget textIcon(text, icon, {Color? color, double? fontsize}) {
  return Text.rich(
    TextSpan(
      children: [
        WidgetSpan(
            child: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: icon,
        )),
        TextSpan(
            text: text,
            style: TextStyle(
              color: color,
              fontSize: fontsize,
            )),
      ],
    ),
  );
}

Widget textIcon_Double(text1, text2, icon,
    {Color? color1, Color? color2, double? fontsize1, double? fontsize2}) {
  return Text.rich(
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
              color: color1,
              fontSize: fontsize1,
            ),
            children: [
              TextSpan(
                  text: text2,
                  style: TextStyle(
                    color: color2,
                    fontSize: fontsize2,
                  )),
            ]),
      ],
    ),
  );
}
