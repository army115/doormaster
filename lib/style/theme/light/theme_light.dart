// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'package:doormster/style/colorSwatch.dart';
import 'package:doormster/style/theme/dark/theme_dark.dart';
import 'package:doormster/style/theme/light/light_components/light_appbar.dart';
import 'package:doormster/style/theme/light/light_components/light_bottomBar.dart';
import 'package:doormster/style/theme/light/light_components/light_dialog.dart';
import 'package:doormster/style/theme/light/light_components/light_drawer.dart';
import 'package:doormster/style/theme/light/light_components/light_expansionTile.dart';
import 'package:doormster/style/theme/light/light_components/light_text.dart';
import 'package:doormster/style/transitions_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';

ThemeData themeLight = ThemeData(
  useMaterial3: false,
  pageTransitionsTheme: transitionsTheme,
  primarySwatch: colorSwatch(Color(0xFF0b4d9c)),
  primaryColor: Color(0xFF0B4D9C),
  primaryColorLight: Colors.blue[700],
  primaryColorDark: Color(0xFF0B4D9C),
  dividerColor: Colors.black,
  expansionTileTheme: Light_ExpansionTile,
  cardTheme: CardTheme(color: Colors.white),
  // accentColor: Colors.transparent, //? Scroll Colors
  textTheme: Light_Text,
  drawerTheme: Light_Drawer,
  dialogTheme: Light_Dialog,
  bottomNavigationBarTheme: Light_BottomBar,
  scaffoldBackgroundColor: Colors.grey[200],
  floatingActionButtonTheme:
      FloatingActionButtonThemeData(backgroundColor: Color(0xFF0B4D9C)),
  appBarTheme: Light_Appbar,
  fontFamily: 'Prompt',
);
