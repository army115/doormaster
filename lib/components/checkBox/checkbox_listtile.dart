import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkbox_Listtile extends StatelessWidget {
  String title;
  Color textColor;
  Color borderColor;
  Color activeColor;
  Color checkColor;
  final value;
  final onChanged;
  Checkbox_Listtile(
      {super.key,
      this.value,
      this.onChanged,
      required this.title,
      required this.textColor,
      required this.borderColor,
      required this.checkColor,
      required this.activeColor});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      side: BorderSide(color: borderColor, width: 2),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      checkColor: checkColor,
      activeColor: activeColor,
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading, // Checkbox position
    );
  }
}
