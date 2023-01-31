// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData mytheme() {
  Map<int, Color> color = {
    50: Color.fromRGBO(11, 77, 156, .1),
    100: Color.fromRGBO(11, 77, 156, .2),
    200: Color.fromRGBO(11, 77, 156, .3),
    300: Color.fromRGBO(11, 77, 156, .4),
    400: Color.fromRGBO(11, 77, 156, .5),
    500: Color.fromRGBO(11, 77, 156, .6),
    600: Color.fromRGBO(11, 77, 156, .7),
    700: Color.fromRGBO(11, 77, 156, .8),
    800: Color.fromRGBO(11, 77, 156, .9),
    900: Color.fromRGBO(11, 77, 156, 1),
  };
  return ThemeData(
    primarySwatch: MaterialColor(0xFF0b4d9c, color),
    primaryColor: Color(0xFF0B4D9C),
    textTheme: TextTheme(
      bodyText2: TextStyle(
        fontSize: 18,
        letterSpacing: 0.5,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF0B4D9C),
    ),
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF0B4D9C)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 25),
        selectedLabelStyle:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 14)),
    scaffoldBackgroundColor: Colors.grey[200],
    appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(size: 30, color: Colors.white),
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Prompt',
          fontSize: 18,
          letterSpacing: 1,
        )),
    fontFamily: 'Prompt',
  );
}
