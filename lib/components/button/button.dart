// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Buttons extends StatelessWidget {
  String title;
  VoidCallback press;
  Buttons({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.mediaQuery.size.width * 0.6,
      height: 45,
      child: ElevatedButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 10,
              primary: Colors.black,
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
}
