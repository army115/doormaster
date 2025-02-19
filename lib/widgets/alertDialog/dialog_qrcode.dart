// ignore_for_file: sort_child_properties_last, prefer_const_constructors, non_constant_identifier_names

import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void dialog_QRcode({
  required GlobalKey qrKey,
  required Widget qrCode,
  required String name,
  required String startDate,
  required String endDate,
  required String textButton1,
  required VoidCallback press1,
  String? textButton2,
  VoidCallback? press2,
}) {
  Get.dialog(AlertDialog(
    contentPadding: const EdgeInsets.symmetric(vertical: 10),
    content: Container(
      padding: EdgeInsets.zero,
      width: Get.mediaQuery.size.width,
      child: SingleChildScrollView(
          child: RepaintBoundary(
        key: qrKey,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          color: Colors.white,
          child: Column(
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              qrCode,
              SizedBox(
                height: 10,
              ),
              Text(
                startDate,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                endDate,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
        ),
      )),
    ),
    actionsAlignment: MainAxisAlignment.spaceEvenly,
    actions: [
      SizedBox(
        width: 90,
        child: ElevatedButton(
          style: styleButtons(EdgeInsets.symmetric(vertical: 5), 10.0,
              Get.theme.primaryColor, BorderRadius.circular(5)),
          child: Text(
            textButton1,
            style: TextStyle(
                fontSize: 16,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          onPressed: press1,
        ),
      ),
      SizedBox(
        width: 90,
        child: ElevatedButton(
          style: styleButtons(EdgeInsets.symmetric(vertical: 5), 10.0,
              Get.theme.primaryColor, BorderRadius.circular(5)),
          child: Text(
            textButton2!,
            style: TextStyle(
                fontSize: 16,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          onPressed: press2,
        ),
      ),
    ],
  ));
}
