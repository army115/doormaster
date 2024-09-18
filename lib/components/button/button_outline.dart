// ignore_for_file: must_be_immutable, sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget Buttons_Outline({required title, required press}) {
  return SizedBox(
    width: Get.mediaQuery.size.width * 0.5,
    height: 45,
    child: OutlinedButton(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Get.theme.primaryColorLight),
            overlayColor: MaterialStateProperty.all(Colors.black26),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.white, width: 1))),
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
