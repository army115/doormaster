// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class Dropdown extends StatelessWidget {
  String title;
  TextEditingController controller;
  IconData? leftIcon;
  String? error;
  final onChanged;
  final listItem;
  Dropdown(
      {Key? key,
      required this.title,
      required this.controller,
      required this.listItem,
      this.error,
      this.leftIcon,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
          borderRadius: BorderRadius.circular(10),
          elevation: 10,
          color: Colors.white,
          child: CustomDropdown(
            excludeSelected: controller.text == (null) ? false : true,
            hideSelectedFieldWhenOpen: false,
            onChanged: onChanged,
            items: listItem,
            controller: controller,
            fieldPrefixIcon: Icon(
              leftIcon,
              size: 25,
            ),
            errorText: error,
            errorStyle: TextStyle(fontSize: 15),
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            searchText: 'ค้นหา',
            foundText: 'ไม่พบข้อมูล',
            borderRadiusItem: BorderRadius.circular(10),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
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
          )),
    );
  }
}
