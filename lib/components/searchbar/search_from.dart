// ignore_for_file: prefer_const_constructors, must_be_immutable, unused_import

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:doormster/screen/security_guard/report_logs_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Search_From extends StatelessWidget {
  String title;
  final changed;
  TextEditingController fieldText;
  final clear;
  Search_From({
    Key? key,
    required this.title,
    this.changed,
    required this.fieldText,
    this.clear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextField(
          cursorColor: Get.theme.primaryColorDark,
          controller: fieldText,
          style: Get.textTheme.bodyText2,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColorDark,
              size: 30,
            ),
            suffixIcon: fieldText.text.length > 0
                ? IconButton(
                    onPressed: clear,
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.red,
                    ))
                : null,
            border: InputBorder.none,
          ),
          onChanged: changed),
    );
  }
}
