// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData mytheme() {
  return ThemeData(
      primarySwatch: Colors.indigo,
      textTheme: TextTheme(
        bodyText2: TextStyle(
          fontSize: 20,
          letterSpacing: 0.5,
        ),
      ),
      scaffoldBackgroundColor: Colors.grey[200],
      appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(size: 30, color: Colors.white),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Prompt',
            fontSize: 22,
            letterSpacing: 1,
          )),
      fontFamily: 'Prompt');
}
