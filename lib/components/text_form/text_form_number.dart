import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextForm_Number extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData icon;
  var error;
  int maxLength;
  TextInputType type;
  TextForm_Number(
      {Key? key,
      required this.controller,
      required this.title,
      required this.icon,
      required this.error,
      required this.type,
      required this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
          style: TextStyle(fontSize: 16),
          controller: controller,
          maxLength: maxLength,
          keyboardType: type,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          decoration: InputDecoration(
            counterText: "",
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
