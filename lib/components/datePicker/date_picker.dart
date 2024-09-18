// ignore_for_file: prefer_const_constructors

import 'package:doormster/components/calendar/calendar.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';

class Date_Picker extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String error;
  final IconData? leftIcon;
  const Date_Picker({
    super.key,
    required this.controller,
    required this.title,
    required this.error,
    this.leftIcon,
  });

  @override
  State<Date_Picker> createState() => _Date_PickerState();
}

class _Date_PickerState extends State<Date_Picker> {
  DateTime dateValue = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: TextFormField(
          style: textStyle().title16,
          controller: widget.controller,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            prefixIcon: Icon(
              widget.leftIcon,
              size: 25,
            ),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 25),
            hintText: widget.title,
            hintStyle: textStyle().title16,
            errorStyle: textStyle().body14,
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
              return widget.error;
            } else {
              return null;
            }
          },
          onTap: () {
            CalendarPicker_SingleDate(context: context, dateValue: dateValue)
                .then(
              (value) {
                if (value != null) {
                  setState(() {
                    widget.controller.text = value;
                    dateValue = DateTime.parse(value);
                  });
                }
              },
            );
          },
        ),
      ),
    );
  }
}
