// ignore_for_file: must_be_immutable, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget Buttons_textIcon({
  required title,
  required icon,
  required press,
  buttonColor,
  textColor,
}) {
  return SizedBox(
    child: ElevatedButton(
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            backgroundColor: buttonColor ?? Get.theme.primaryColorDark),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor ?? Get.textTheme.bodyLarge?.color,
            ),
            const SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(
                  fontSize: 15,
                  color: textColor ?? Get.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
        onPressed: press),
  );
}
