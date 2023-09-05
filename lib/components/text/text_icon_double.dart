import 'package:flutter/material.dart';

Widget textDouble_iconLeft(text1, text2, icon,
    {Color? color, double? fontsize}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 5),
        child: icon,
      ),
      Expanded(
        child: Text.rich(
          TextSpan(
              text: text1,
              style: TextStyle(
                color: color,
                fontSize: fontsize,
              ),
              children: [
                TextSpan(
                    text: text2,
                    style: TextStyle(
                      color: color,
                      fontSize: fontsize,
                    ))
              ]),
        ),
      ),
    ],
  );
}

Widget textDouble_iconRight(text1, text2, icon,
    {Color? color, double? fontsize, TextOverflow? overflow}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text.rich(
          overflow: overflow,
          TextSpan(
            children: [
              TextSpan(
                  text: text1,
                  style: TextStyle(
                    color: color,
                    fontSize: fontsize,
                  )),
              TextSpan(
                text: text2,
                style: TextStyle(
                  color: color,
                  fontSize: fontsize,
                ),
              ),
            ],
          ),
        ),
      ),
      icon
    ],
  );
}
