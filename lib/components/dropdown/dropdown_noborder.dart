import 'package:flutter/material.dart';

class Dropdown_NoBorder extends StatelessWidget {
  final title;
  var values;
  final listItem;
  final leftIcon;
  final validate;
  final onChange;
  Dropdown_NoBorder(
      {Key? key,
      this.title,
      this.values,
      this.listItem,
      this.leftIcon,
      this.validate,
      this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField(
          hint: Text(title),
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'Prompt',
              color: Colors.black,
              height: 1.2),
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(fontSize: 16),
            prefixIcon: Icon(
              leftIcon,
              size: 25,
            ),
            // border: InputBorder.none,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
            errorStyle: TextStyle(fontSize: 15),
          ),
          value: values,
          icon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          items: listItem,
          onChanged: onChange,
          validator: validate),
    );
  }
}