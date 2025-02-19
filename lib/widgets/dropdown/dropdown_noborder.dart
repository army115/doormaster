// ignore_for_file: must_be_immutable

import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:get/get.dart';

class Dropdown_NoBorder extends StatelessWidget {
  final String title;
  // TextEditingController controller;
  final IconData? leftIcon;
  final String? error;
  final onChanged;
  final listItem;
  final GlobalKey? fieldKey;
  const Dropdown_NoBorder(
      {super.key,
      required this.title,
      // required this.controller,
      required this.listItem,
      this.error,
      this.leftIcon,
      this.onChanged,
      this.fieldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 0,
        color: Colors.transparent,
        child: CustomDropdown(
          excludeSelected: false,
          hideSelectedFieldWhenExpanded: true,
          onChanged: onChanged,
          items: listItem,
          hintText: title,
          validator: (value) {
            if (value == null) {
              return "  $error";
            } else {
              return null;
            }
          },
          maxlines: 2,
          listItemPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 13),
          closedHeaderPadding: const EdgeInsets.symmetric(vertical: 13),
          decoration: CustomDropdownDecoration(
              listItemStyle: const TextStyle(color: Colors.black),
              headerStyle: Get.textTheme.bodySmall,
              errorStyle: textStyle.body14,
              closedFillColor: Colors.transparent,
              prefixIcon: leftIcon == null
                  ? null
                  : Icon(
                      leftIcon,
                      size: 28,
                      color: Get.theme.dividerColor,
                    ),
              closedSuffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 25,
                color: Theme.of(context).dividerColor,
              ),
              expandedSuffixIcon: const Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 25,
              ),
              closedBorderRadius: BorderRadius.circular(0),
              closedBorder: Border(
                  bottom:
                      BorderSide(color: Get.theme.dividerColor, width: 1.5)),
              closedErrorBorderRadius: BorderRadius.circular(0),
              closedErrorBorder:
                  const Border(bottom: BorderSide(color: Colors.red, width: 2)),
              expandedBorder:
                  Border.all(color: Theme.of(context).primaryColor, width: 2)),
        ),
      ),
    );
  }
}
