import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  final title;
  final values;
  final listItem;
  final leftIcon;
  final rightIcon;
  final onChange;
  final validate;
  Dropdown(
      {Key? key,
      required this.title,
      required this.values,
      required this.listItem,
      required this.leftIcon,
      required this.rightIcon,
      required this.validate,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: DropdownButtonFormField(
          style: TextStyle(fontSize: 20, color: Colors.black),
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(fontSize: 20),
            prefixIcon: leftIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 10.0),
            errorStyle: TextStyle(fontSize: 18),
          ),
          value: values,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          items: listItem,
          onChanged: onChange,
          validator: validate),
    );
  }
}
