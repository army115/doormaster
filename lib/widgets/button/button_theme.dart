// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, sort_child_properties_last

import 'package:doormster/controller/theme_controller.dart';
import 'package:flutter/material.dart';

Widget manu_theme(colorCard, colorIcon) => Card(
    color: colorCard,
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    child: PopupMenuButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        position: PopupMenuPosition.under,
        elevation: 3,
        icon: Icon(Icons.dark_mode_rounded, size: 30, color: colorIcon),
        onSelected: (value) => themeController.setThemeMode(value),
        itemBuilder: (context) => [
              PopupMenuItem(
                value: ThemeMode.light,
                child: Center(child: Text('ปิด')),
              ),
              PopupMenuItem(
                value: ThemeMode.dark,
                child: Center(child: Text('เปิด')),
              ),
              PopupMenuItem(
                value: ThemeMode.system,
                child: Center(child: Text('ระบบ')),
              ),
            ]));
