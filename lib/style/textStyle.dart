import 'package:flutter/material.dart';

class textStyle {
  TextStyle Header18 = TextStyle(fontSize: 18, color: Colors.black);
  TextStyle title16 = TextStyle(fontSize: 16);
  TextStyle body14 = TextStyle(fontSize: 14);
  TextStyle body12 = TextStyle(fontSize: 12);
}

Widget myTextScale(BuildContext context, Widget? child) {
  return MediaQuery(
      // fix ขนาดตัวอักษรของแอพ
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.2,
      ),
      child: child!);
}
