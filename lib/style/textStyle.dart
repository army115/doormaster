import 'package:flutter/material.dart';

class textStyle {
  textStyle._();
  static TextStyle header18 =
      const TextStyle(fontSize: 18, color: Colors.black);
  static TextStyle title16 = const TextStyle(fontSize: 16);
  static TextStyle body14 = const TextStyle(fontSize: 14);
  static TextStyle body12 = const TextStyle(fontSize: 12);
}

Widget myTextScale(BuildContext context, Widget? child) {
  return MediaQuery(
      // fix ขนาดตัวอักษรของแอพ
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.1,
      ),
      child: child!);
}
