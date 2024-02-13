// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

BottomNavigationBarThemeData Light_BottomBar = BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Color(0xFF0B4D9C),
    elevation: 10,
    showUnselectedLabels: true,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey[400],
    selectedIconTheme: IconThemeData(size: 30),
    unselectedIconTheme: IconThemeData(size: 25),
    selectedLabelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 14));
