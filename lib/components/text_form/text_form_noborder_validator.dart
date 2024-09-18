// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import

import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/style/textStyle.dart';

class TextForm_NoBorder_Validator extends StatelessWidget {
  TextEditingController controller;
  String title;
  var icon;
  final validator;
  var typeInput;
  TextForm_NoBorder_Validator(
      {Key? key,
      required this.controller,
      required this.title,
      this.icon,
      this.validator,
      required this.typeInput})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        minLines: 1,
        maxLines: 5,
        autofocus: false,
        style: Get.textTheme.bodySmall,
        controller: controller,
        keyboardType: typeInput,
        cursorColor: Theme.of(context).primaryColorDark,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 10),
          labelText: title,
          labelStyle: TextStyle(color: Colors.grey),
          floatingLabelStyle:
              TextStyle(color: Theme.of(context).primaryColorDark),
          hintText: "enter_info".tr,
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
          errorStyle: textStyle().body14,
          prefixIcon: Icon(icon, size: 30),
          prefixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return Theme.of(context).primaryColorDark;
            }
            return Theme.of(context).dividerColor.withOpacity(0.5);
          }),
          suffixIconColor:
              MaterialStateColor.resolveWith((Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) {
              return Theme.of(context).primaryColorDark;
            }
            return Theme.of(context).dividerColor.withOpacity(0.5);
          }),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColorDark, width: 2)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                  width: 1.5)),
        ),
        validator: validator,
      ),
    );
  }
}
