// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dropdown_Search extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final IconData? leftIcon;
  final String? error;
  final onChanged;
  final listItem;
  final GlobalKey? fieldKey;
  const Dropdown_Search(
      {super.key,
      required this.title,
      required this.controller,
      required this.listItem,
      this.error,
      this.leftIcon,
      this.onChanged,
      this.fieldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          color: Colors.white,
          child: CustomDropdown.search(
            excludeSelected: false,
            onChanged: onChanged,
            hintText: title,
            items: listItem,
            searchHintText: 'search'.tr,
            noResultFoundText: 'data_not_found'.tr,
            validator: (value) {
              if (value == null) {
                return "  $error";
              } else {
                return null;
              }
            },
            maxlines: 2,
            listItemPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            expandedHeaderPadding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            closedHeaderPadding:
                EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            decoration: CustomDropdownDecoration(
              hintStyle: TextStyle(color: Colors.grey[700]),
              listItemStyle: const TextStyle(color: Colors.black),
              headerStyle: const TextStyle(color: Colors.black),
              errorStyle: textStyle.body14,
              closedSuffixIcon:
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 25),
              expandedSuffixIcon:
                  const Icon(Icons.keyboard_arrow_up_rounded, size: 25),
              prefixIcon: leftIcon == null
                  ? null
                  : Icon(
                      leftIcon,
                      size: 25,
                    ),
              // closedBorder:
              //     Border.all(color: Theme.of(context).primaryColor, width: 2),
              // closedErrorBorder:
              //     Border.fromBorderSide(BorderSide(color: Colors.red)),
              expandedBorder: Border.fromBorderSide(
                BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
              ),
            ),
          )),
    );
  }
}
