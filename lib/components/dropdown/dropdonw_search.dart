// ignore_for_file: must_be_immutable

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:doormster/style/theme.dart';
import 'package:flutter/material.dart';

class Dropdown_Search extends StatelessWidget {
  String title;
  TextEditingController controller;
  IconData? leftIcon;
  String? error;
  final onChanged;
  final listItem;
  Dropdown_Search(
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
          child: CustomDropdown.search(
            excludeSelected: false,
            hideSelectedFieldWhenOpen: false,
            onChanged: onChanged,
            fieldPrefixIcon: Icon(
              leftIcon,
              size: 25,
            ),
            errorText: error,
            errorStyle: textStyle().body14,
            hintText: title,
            searchText: 'ค้นหา',
            foundText: 'ไม่พบข้อมูล',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            items: listItem,
            controller: controller,
            borderRadiusItem: BorderRadius.circular(10),
            contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
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
