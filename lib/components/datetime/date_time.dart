import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class Date_time extends StatelessWidget {
  final controller;
  final title;
  final leftIcon;
  final rightIcon;
  final theme;
  final language;
  final onConfirm;
  final error;

  Date_time(
      {Key? key,
      required this.controller,
      required this.title,
      required this.leftIcon,
      required this.rightIcon,
      required this.theme,
      required this.language,
      required this.onConfirm,
      required this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(fontSize: 20),
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          prefixIcon: leftIcon,
          suffixIcon: rightIcon,
          // labelText: 'Username',
          hintText: title,
          hintStyle: TextStyle(fontSize: 20),
          errorStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
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
        onTap: () {
          DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            onConfirm: onConfirm,
            currentTime: DateTime.now(),
            locale: language,
            theme: theme,
          );
        },
      ),
    );
  }
}
