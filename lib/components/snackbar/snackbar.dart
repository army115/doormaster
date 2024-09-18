import 'package:flutter/material.dart';
import 'package:get/get.dart';

void snackbar(
  color,
  title,
  icon,
) {
  Get.showSnackbar(GetSnackBar(
    icon: Icon(
      icon,
      color: Colors.white,
      size: 30,
    ),
    messageText: Text(
      title,
      style: TextStyle(fontSize: 16, color: Colors.white),
    ),
    backgroundColor: color,
    borderRadius: 5,
    dismissDirection: DismissDirection.none,
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    shouldIconPulse: false,
    duration: const Duration(milliseconds: 1700),
    animationDuration: Duration(milliseconds: 700),
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    reverseAnimationCurve: Curves.fastOutSlowIn,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        spreadRadius: 3,
        blurRadius: 5,
        offset: Offset(0, 2),
      ),
    ],
  ));
}
