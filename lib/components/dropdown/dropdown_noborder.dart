// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class Dropdown_NoBorder extends StatelessWidget {
  String title;
  TextEditingController controller;
  IconData? leftIcon;
  String? error;
  final onChanged;
  final listItem;
  Dropdown_NoBorder(
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
      child: CustomDropdown(
        excludeSelected: controller.text == (null) ? false : true,
        hideSelectedFieldWhenOpen: false,
        onChanged: onChanged,
        items: listItem,
        controller: controller,
        fillColor: Colors.grey.shade200,
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
        // borderRadiusItem: BorderRadius.circular(5),
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
      ),
    );
  }
}
