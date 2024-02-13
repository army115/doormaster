import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckBox_FormField extends StatelessWidget {
  final title;
  final value;
  final onChanged;
  final validator;
  final secondary;
  const CheckBox_FormField(
      {Key? key,
      this.title,
      this.value,
      this.validator,
      this.secondary,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTileFormField(
      side: BorderSide(color: Get.theme.dividerColor, width: 2),
      checkColor: Get.textTheme.bodyText1?.color,
      secondary: secondary,
      dense: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      activeColor: Get.theme.primaryColorDark,
      title: Text(
        title,
        style: Get.textTheme.bodyText2,
      ),
      initialValue: value,
      onChanged: onChanged,
      validator: (values) {
        if (values!) {
          return null;
        } else {
          return validator;
        }
      },
    );
  }
}
