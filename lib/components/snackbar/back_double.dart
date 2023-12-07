import 'package:flutter/material.dart';
import 'package:get/get.dart';

void backDouble(context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.none,
      backgroundColor: Get.theme.primaryColor,
      content: Text(
        "press_again".tr,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, fontFamily: 'Kanit'),
      ),
      width: 170,
      padding: EdgeInsets.symmetric(vertical: 10),
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    ),
  );
}
