// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dropdonw_searchRequest extends StatelessWidget {
  final String title;
  final String error;
  final IconData? leftIcon;
  final onChanged;
  final futureRequest;
  final GlobalKey? fieldKey;
  const Dropdonw_searchRequest(
      {super.key,
      required this.futureRequest,
      required this.title,
      required this.error,
      this.leftIcon,
      this.onChanged,
      this.fieldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: CustomDropdown.searchRequest(
          excludeSelected: false,
          futureRequestDelay: Duration(milliseconds: 800),
          key: fieldKey,
          futureRequest: futureRequest,
          hintText: title,
          validator: (value) {
            if (value == null) {
              return "  $error";
            } else {
              return null;
            }
          },
          searchHintText: 'search'.tr,
          noResultFoundText: 'data_not_found'.tr,
          overlayHeight: 400,
          listItemPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          expandedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          closedHeaderPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          decoration: CustomDropdownDecoration(
            hintStyle: TextStyle(color: Colors.grey[700]),
            listItemStyle: const TextStyle(color: Colors.black),
            headerStyle: const TextStyle(color: Colors.black),
            noResultFoundStyle: TextStyle(color: Colors.grey[700]),
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
            expandedBorder:
                Border.all(color: Theme.of(context).primaryColor, width: 2),
            closedErrorBorder: const Border.fromBorderSide(
                BorderSide(color: Colors.red, width: 1.5)),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
