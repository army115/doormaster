// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import

import 'package:doormster/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextForm_NoBorder_Validator extends StatelessWidget {
  TextEditingController controller;
  String title;
  var icon;
  final validator;
  var typeInput;
  TextForm_NoBorder_Validator(
      {Key? key,
      required this.controller,
      required this.title,
      this.icon,
      this.validator,
      required this.typeInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        autofocus: false,
        style: textStyle().title16,
        controller: controller,
        keyboardType: typeInput,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 10),
          labelText: title,
          hintText: "enter_info".tr,
          hintStyle: textStyle().title16,
          errorStyle: textStyle().body14,
          prefixIcon: Icon(icon, size: 25),
        ),
        validator: validator,
      ),
    );
  }
}
