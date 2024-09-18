// ignore_for_file: must_be_immutable, use_super_parameters

import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class Dropdown extends StatelessWidget {
  String title;
  TextEditingController? controller;
  IconData? leftIcon;
  String? error;
  ValueChanged<String?> onChanged;
  List<String> listItem;
  Dropdown({
    Key? key,
    required this.title,
    required this.listItem,
    required this.onChanged,
    this.controller,
    this.error,
    this.leftIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: CustomDropdown(
          controller: controller == null
              ? null
              : SingleSelectController(
                  controller!.text.isNotEmpty ? controller!.text : null,
                ),
          hideSelectedFieldWhenExpanded:
              controller == null || controller!.text.isNotEmpty ? true : false,
          excludeSelected: false,
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
          overlayHeight: 400,
          listItemPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          expandedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          closedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          disabledDecoration: CustomDropdownDisabledDecoration(
              border: Border.all(color: Colors.red)),
          decoration: CustomDropdownDecoration(
            errorStyle: textStyle().body14,
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
            expandedBorder:
                Border.all(color: Theme.of(context).primaryColor, width: 2),
            closedErrorBorder: const Border.fromBorderSide(
                BorderSide(color: Colors.red, width: 1.5)),
          ),
        ),
      ),
    );
  }
}
