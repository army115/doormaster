// ignore_for_file: must_be_immutable, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget Buttons({required title, required press}) {
  return SizedBox(
    width: Get.mediaQuery.size.width * 0.6,
    height: 45,
    child: ElevatedButton(
        style: TextButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 10,
            backgroundColor: Get.theme.primaryColor),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.normal,
            letterSpacing: 1,
          ),
        ),
        onPressed: press),
  );
}
