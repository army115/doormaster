import 'package:flutter/material.dart';

class TextForm_validator extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData icon;
  var error;
  var TypeInput;
  TextForm_validator(
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
          style: TextStyle(fontSize: 16),
          controller: controller,
          keyboardType: TypeInput,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            // labelText: 'Username',
            hintText: title,
            hintStyle: TextStyle(fontSize: 16),
            errorStyle: TextStyle(fontSize: 15),
            // ignore: prefer_const_constructors
            prefixIcon: Icon(
              icon,
              size: 25,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: error),
    );
  }
}
