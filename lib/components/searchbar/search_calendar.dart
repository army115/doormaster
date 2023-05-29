// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

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
    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: TextField(
          readOnly: true,
          controller: fieldText,
          style: TextStyle(
              fontSize: 15,
              color: fieldText.text.contains('ค้นหา')
                  ? Colors.grey
                  : Colors.black),
          // cursorColor: Colors.cyan,
          decoration: InputDecoration(
            hintText: title,
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
          onTap: ontap,
          onChanged: changed),
    );
  }
}
