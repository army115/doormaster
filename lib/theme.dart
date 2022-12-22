// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData mytheme() {
  Map<int, Color> color = {
    50: Color.fromRGBO(0, 90, 171, .1),
    100: Color.fromRGBO(0, 90, 171, .2),
    200: Color.fromRGBO(0, 90, 171, .3),
    300: Color.fromRGBO(0, 90, 171, .4),
    400: Color.fromRGBO(0, 90, 171, .5),
    500: Color.fromRGBO(0, 90, 171, .6),
    600: Color.fromRGBO(0, 90, 171, .7),
    700: Color.fromRGBO(0, 90, 171, .8),
    800: Color.fromRGBO(0, 90, 171, .9),
    900: Color.fromRGBO(0, 90, 171, 1),
  };
  return ThemeData(
    primarySwatch: MaterialColor(0xFF005AAB, color),
    primaryColor: Color(0xFF005AAB),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        fontSize: 20,
        letterSpacing: 0.5,
      ),
    ),
    scaffoldBackgroundColor: Colors.grey[200],
    appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(size: 30, color: Colors.white),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Prompt',
          fontSize: 22,
          letterSpacing: 1,
        )),
    fontFamily: 'Prompt',
  );
}
