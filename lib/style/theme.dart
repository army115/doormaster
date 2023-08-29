// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'dart:io';

class textStyle {
  TextStyle Header18 = TextStyle(fontSize: 18);
  TextStyle title16 = TextStyle(fontSize: 16);
  TextStyle body14 = TextStyle(fontSize: 14);
  TextStyle body12 = TextStyle(fontSize: 12);
}

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
    //animetion การเปลี่ยนหน้า
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder()
      },
    ),
    primarySwatch: MaterialColor(0xFF0b4d9c, color),
    primaryColor: Color(0xFF0B4D9C),
    // accentColor: Colors.transparent, //? Scroll Colors
    textTheme: TextTheme(
      bodyText2: TextStyle(
        fontSize: 16,
        letterSpacing: 0.5,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Color(0xFF0B4D9C),
    ),
    dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: 'Prompt')),
    bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF0B4D9C)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 10,
        showUnselectedLabels: true,
        selectedItemColor: Color(0xFF0B4D9C),
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(size: 30),
        unselectedIconTheme: IconThemeData(size: 25),
        selectedLabelStyle:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 14)),
    scaffoldBackgroundColor: Colors.grey[200],
    appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF0B4D9C),
        centerTitle: true,
        iconTheme: IconThemeData(size: 30, color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Prompt',
          fontSize: 16,
          letterSpacing: 1,
        )),
    fontFamily: 'Prompt',
  );
}

Widget myTextScale(BuildContext context, Widget? child) {
  return MediaQuery(
      // fix ขนาดตัวอักษรของแอพ
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: 1.2,
      ),
      child: child!);
}

Widget myScrollScreen(BuildContext context, Widget? child) {
  return ScrollConfiguration(
    // scroll listview screen การเลื่อนไลด์หน้าแอพ
    behavior: ScrollBehavior().copyWith(
        // Set the default scroll physics here
        physics: BouncingScrollPhysics()
        // Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics(),
        ),
    child: child!,
  );
}
