// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Search_Calendar extends StatelessWidget {
  String title;
  final changed;
  final fieldText;
  final clear;
  final ontap;
  Search_Calendar(
      {Key? key,
      required this.title,
      this.changed,
      this.clear,
      this.ontap,
      this.fieldText})
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
                  : Get.textTheme.bodyText2?.color),
          // cursorColor: Colors.cyan,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            prefixIcon: Icon(
              Icons.event_note,
              color: Get.theme.primaryColorDark,
              size: 30,
            ),
            suffixIcon: fieldText.text.contains('วันที่') ||
                    fieldText.text.contains('Select')
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
          onChanged: changed),
    );
  }
}
