// ignore_for_file: must_be_immutable

import 'package:doormster/style/textStyle.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CustomDropdown(
        excludeSelected: false,
        hideSelectedFieldWhenOpen: true,
        onChanged: onChanged,
        items: listItem,
        controller: controller,
        fillColor: Colors.transparent,
        fieldPrefixIcon: Icon(
          leftIcon,
          size: 30,
        ),

        fieldSuffixIcon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 30,
        ),
        suffixIconColor:
            MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.focused)) {
            return Theme.of(context).dividerColor;
          }
          return Theme.of(context).dividerColor.withOpacity(0.5);
        }),
        prefixIconColor:
            MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.focused)) {
            return Theme.of(context).primaryColorDark;
          }
          return Theme.of(context).dividerColor.withOpacity(0.5);
        }),
        listItemStyle: const TextStyle(color: Colors.black),
        errorText: error,
        errorStyle: textStyle().body14,
        hintText: title,
        hintStyle: const TextStyle(color: Colors.grey),
        selectedStyle: Get.textTheme.bodyText2,
        searchText: 'search'.tr,
        foundText: 'data_not_found'.tr,
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColorDark, width: 2)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5)),
        // borderRadiusItem: BorderRadius.circular(5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
      ),
    );
  }
}
