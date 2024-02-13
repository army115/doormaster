// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import
import 'package:doormster/style/colorSwatch.dart';
import 'package:doormster/style/theme/dark/dark_components/dark_appbar.dart';
import 'package:doormster/style/theme/dark/dark_components/dark_bottomBar.dart';
import 'package:doormster/style/theme/dark/dark_components/dark_dialog.dart';
import 'package:doormster/style/theme/dark/dark_components/dark_drawer.dart';
import 'package:doormster/style/theme/dark/dark_components/dark_expansionTile.dart';
import 'package:doormster/style/theme/dark/dark_components/dark_text.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:doormster/style/transitions_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';

ThemeData themeDark = ThemeData(
  useMaterial3: false,
  pageTransitionsTheme: transitionsTheme,
  primarySwatch: colorSwatch(Color(0xDD000000)),
  primaryColor: Colors.grey[900],
  primaryColorLight: Colors.grey[700],
  primaryColorDark: Colors.white,
  dividerColor: const Color.fromRGBO(255, 255, 255, 1),
  cardTheme: CardTheme(color: Colors.grey[900], shadowColor: Colors.white30),
  // accentColor: Colors.transparent, //? Scroll Colors
  textTheme: Dark_Text,
  drawerTheme: Drak_Drawer,
  expansionTileTheme: Drak_ExpansionTile,
  dialogTheme: Dark_Dialog,
  bottomNavigationBarTheme: Dark_BottomBar,
  scaffoldBackgroundColor: Colors.grey[700],
  appBarTheme: Dark_Appbar,
  fontFamily: 'Prompt',
);
