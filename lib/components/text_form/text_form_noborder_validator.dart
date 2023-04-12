// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextForm_NoBorder_Validator extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData icon;
  final validator;
  var typeInput;
  TextForm_NoBorder_Validator(
      {Key? key,
      required this.controller,
      required this.title,
      required this.icon,
      this.validator,
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
        validator: validator,
      ),
    );
  }
}
