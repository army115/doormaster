// ignore_for_file: prefer_const_constructors

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:doormster/screen/security_guard/record_check_page.dart';
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
    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: TextField(
          controller: fieldText,
          style: TextStyle(fontSize: 15),
          // cursorColor: Colors.cyan,
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            suffixIcon: fieldText.text.length > 0
                ? IconButton(
                    onPressed: clear,
                    icon: Icon(
                      Icons.close,
                    ))
                : null,
            // suffixIcon: Icon(
            //   Icons.event_note,
            //   color: Theme.of(context).primaryColor,
            //   size: 30,
            // ),
            //     IconButton(
            //         onPressed: () => calenda(),
            //     Icon(
            //   Icons.event_note,
            //   color: Theme.of(context).primaryColor,
            //   size: 30,
            // )
            // ),
            border: InputBorder.none,
          ),
          onChanged: changed),
    );
  }
}
