// ignore_for_file: must_be_immutable

import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class Dropdown_NoBorder extends StatelessWidget {
  String title;
  // TextEditingController controller;
  IconData? leftIcon;
  String? error;
  final onChanged;
  final listItem;
  Dropdown_NoBorder(
      {Key? key,
      required this.title,
      // required this.controller,
      required this.listItem,
      this.error,
      this.leftIcon,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
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
          expandedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
          closedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 13),
          decoration: CustomDropdownDecoration(
            errorStyle: textStyle().body14,
            prefixIcon: leftIcon == null
                ? null
                : Icon(
                    leftIcon,
                    size: 25,
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
            // closedBorder:
            //     Border.all(color: Theme.of(context).primaryColor, width: 2),
            // closedErrorBorder:
            //     Border.fromBorderSide(BorderSide(color: Colors.red)),
            expandedBorder: Border.fromBorderSide(
              BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
          // suffixIconColor:
          //     MaterialStateColor.resolveWith((Set<MaterialState> states) {
          //   if (states.contains(MaterialState.focused)) {
          //     return Theme.of(context).dividerColor;
          //   }
          //   return Theme.of(context).dividerColor.withOpacity(0.5);
          // }),
          // prefixIconColor:
          //     MaterialStateColor.resolveWith((Set<MaterialState> states) {
          //   if (states.contains(MaterialState.focused)) {
          //     return Theme.of(context).primaryColorDark;
          //   }
          //   return Theme.of(context).dividerColor.withOpacity(0.5);
          // }),
          // listItemStyle: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
