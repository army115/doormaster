// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import, prefer_const_constructors

import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/style/textStyle.dart';

class Text_Form_NoBorder extends StatelessWidget {
  TextEditingController controller;
  String title;
  var icon;
  String error;
  var TypeInput;
  final GlobalKey fieldKey;
  Text_Form_NoBorder(
      {Key? key,
      required this.controller,
      required this.title,
      required this.icon,
      required this.error,
      required this.TypeInput,
      required this.fieldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      controller: controller,
      style: Get.textTheme.bodySmall,
      cursorColor: Theme.of(context).primaryColorDark,
      keyboardType: TypeInput,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: title,
        hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
        errorStyle: textStyle.body14,
        icon: icon,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 2)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5)),
      ),
      validator: (values) {
        if (values!.isEmpty) {
          return error;
        } else {
          return null;
        }
      },
    );
  }
}
