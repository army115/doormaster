import 'package:flutter/material.dart';

class TextForm_Password extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData iconLaft;
  var error;
  bool redEye;
  var iconRight;
  TextForm_Password(
      {Key? key,
      required this.controller,
      required this.title,
      required this.iconLaft,
      required this.error,
      required this.redEye,
      required this.iconRight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
          obscureText: redEye,
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
            prefixIcon: Icon(
              iconLaft,
              size: 30,
            ),
            suffixIcon: iconRight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          validator: error),
    );
  }
}
