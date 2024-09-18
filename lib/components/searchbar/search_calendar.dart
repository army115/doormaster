// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables, use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search_Calendar extends StatelessWidget {
  String title;
  final fieldText;
  final clear;
  final ontap;
  Search_Calendar(
      {Key? key, required this.title, this.clear, this.ontap, this.fieldText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: TextField(
        readOnly: true,
        controller: fieldText,
        style: TextStyle(
            fontSize: 15,
            color: fieldText.text.contains('วันที่') ||
                    fieldText.text.contains('Select')
                ? Colors.grey
                : Get.textTheme.bodySmall?.color),
        decoration: InputDecoration(
          hintText: title,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
          prefixIcon: Icon(
            Icons.event_note,
            color: Theme.of(context).primaryColorDark,
            size: 30,
          ),
          suffixIcon: fieldText.text.contains('วันที่') ||
                  fieldText.text.contains('Select') ||
                  fieldText.text == ''
              ? null
              : IconButton(
                  onPressed: clear,
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.red,
                  )),
          border: InputBorder.none,
        ),
        onTap: ontap,
      ),
    );
  }
}
