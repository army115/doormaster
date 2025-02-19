// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:doormster/utils/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                  await SecureStorageUtils.writeString("language", 'th');
                  Get.updateLocale(Locale('th'));
                },
                child: Center(child: Text('TH')),
              ),
              PopupMenuItem(
                onTap: () async {
                  await SecureStorageUtils.writeString("language", 'en');
                  Get.updateLocale(Locale('en'));
                },
                child: Center(child: Text('EN')),
              ),
            ]));
