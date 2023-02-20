// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Text_Form_NoBorder extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData icon;
  String error;
  var TypeInput;
  Text_Form_NoBorder(
      {Key? key,
      required this.controller,
      required this.title,
      required this.icon,
      required this.error,
      required this.TypeInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        autofocus: false,
        // readOnly: true,
        style: TextStyle(fontSize: 16),
        controller: controller,
        keyboardType: TypeInput,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 10),
          labelText: title,
          hintText: "กรอกข้อมูล",
          hintStyle: TextStyle(fontSize: 16),
          errorStyle: TextStyle(fontSize: 15),
          // ignore: prefer_const_constructors
          icon: Icon(icon, size: 25),
        ),
        validator: (values) {
          if (values!.isEmpty) {
            return error;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
