// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'package:doormster/style/textStyle.dart';
import 'package:get/get.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';

class Text_Form extends StatelessWidget {
  TextEditingController controller;
  String title;
  IconData icon;
  String error;
  var TypeInput;
  Text_Form(
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
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: TextFormField(
          autofocus: false,
          style: textStyle().title16,
          controller: controller,
          keyboardType: TypeInput,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            // labelText: 'Username',
            hintText: title,
            hintStyle: textStyle().title16,
            errorStyle: textStyle().body14,
            prefixIcon: Icon(icon, size: 25),
            // filled: true, พื้นหลังช่อง
            // fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
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
      ),
    );
  }
}
