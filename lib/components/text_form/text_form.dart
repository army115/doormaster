// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Text_Form extends StatelessWidget {
  TextEditingController controller;
  String title;
  Icon icon;
  Text_Form(
      {Key? key,
      required this.controller,
      required this.title,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(fontSize: 20),
        controller: controller,
        decoration: InputDecoration(
          prefixIconColor: Colors.green,
          contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          // labelText: 'Username',
          hintText: title,
          hintStyle: TextStyle(fontSize: 20),
          errorStyle: TextStyle(fontSize: 15),
          // ignore: prefer_const_constructors
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (values) {
          if (values!.isEmpty) {
            return 'Please enter your username';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
