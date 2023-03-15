// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Text_Form_NoValidator extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData icon;
  String error;
  String validator;
  var typeInput;
  Text_Form_NoValidator(
      {Key? key,
      required this.controller,
      required this.title,
      required this.icon,
      required this.error,
      required this.validator,
      required this.typeInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
          autofocus: false,
          style: TextStyle(fontSize: 16),
          controller: controller,
          keyboardType: typeInput,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 10),
            labelText: title,
            hintText: "กรอกข้อมูล",
            hintStyle: TextStyle(fontSize: 16),
            errorStyle: TextStyle(fontSize: 15),
            prefixIcon: Icon(icon, size: 25),
          ),
          validator: validator == 'ไม่ปกติ'
              ? (values) {
                  if (values!.isEmpty) {
                    return error;
                  } else {
                    return null;
                  }
                }
              : (values) {
                  return null;
                }),
    );
  }
}
