// ignore_for_file: prefer_const_constructors

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:doormster/screen/security_guard/record_check_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Search_Bar extends StatefulWidget {
  String title;
  final changed;
  var fieldText;
  final clear;
  final ontap;
  Search_Bar(
      {Key? key,
      required this.title,
      this.changed,
      this.fieldText,
      this.clear,
      this.ontap})
      : super(key: key);

  @override
  State<Search_Bar> createState() => _Search_BarState();
}

class _Search_BarState extends State<Search_Bar> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: TextField(
          readOnly: true,
          controller: widget.fieldText,
          style: TextStyle(fontSize: 15),
          // cursorColor: Colors.cyan,
          decoration: InputDecoration(
            hintText: widget.title,
            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            prefixIcon: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            suffixIcon: Icon(
              Icons.event_note,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            //     IconButton(
            //         onPressed: () => calenda(),
            //     Icon(
            //   Icons.event_note,
            //   color: Theme.of(context).primaryColor,
            //   size: 30,
            // )
            // ),
            border: InputBorder.none,
            // contentPadding:
            //     EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
          onTap: widget.ontap,
          onChanged: widget.changed),
    );
  }
}
