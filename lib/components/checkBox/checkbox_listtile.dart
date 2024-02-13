import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Checkbox_Listtile extends StatelessWidget {
  String title;
  final value;
  final onChanged;
  Checkbox_Listtile(
      {super.key, this.value, this.onChanged, required this.title});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      side: BorderSide(color: Get.theme.dividerColor, width: 2),
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: Get.textTheme.bodyText2,
      ),
      checkColor: Get.textTheme.bodyText1?.color,
      activeColor: Get.theme.primaryColorDark,
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading, // Checkbox position
    );
  }
}
