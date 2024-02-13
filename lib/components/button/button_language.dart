// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget button_language(colorCard, colorIcon) => Card(
    color: colorCard,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        constraints: BoxConstraints(maxWidth: Get.mediaQuery.size.width * 0.2),
        position: PopupMenuPosition.under,
        elevation: 3,
        icon: Icon(Icons.translate_rounded, size: 30, color: colorIcon),
        itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("language", 'th');
                  Get.updateLocale(Locale('th'));
                },
                child: Center(child: Text('TH')),
              ),
              PopupMenuItem(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString("language", 'en');
                  Get.updateLocale(Locale('en'));
                },
                child: Center(child: Text('EN')),
              ),
            ]));
