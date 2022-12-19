// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Text_Form extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData icon;
  String error;
  Text_Form(
      {Key? key,
      required this.controller,
      required this.title,
      required this.icon,
      required this.error})
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
          errorStyle: TextStyle(fontSize: 18),
          // ignore: prefer_const_constructors
          prefixIcon: Icon(icon, size: 30),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
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
