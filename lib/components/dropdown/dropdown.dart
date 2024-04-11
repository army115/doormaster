// ignore_for_file: must_be_immutable

import 'package:doormster/style/textStyle.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';

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
          elevation: 3,
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
            errorStyle: textStyle().body14,
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            listItemStyle: TextStyle(color: Colors.black),
            selectedStyle: TextStyle(color: Colors.black),
            searchText: 'search'.tr,
            foundText: 'data_not_found'.tr,
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
