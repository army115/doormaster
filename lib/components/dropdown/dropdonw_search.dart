import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dropdown_Search extends StatelessWidget {
  String title;
  TextEditingController controller;
  IconData leftIcon;
  String error;
  final onSelected;
  final listItem;
  // double width;
  // double height;
  Dropdown_Search(
      {Key? key,
      required this.title,
      required this.controller,
      this.listItem,
      // required this.width,
      // required this.height,
      required this.error,
      required this.leftIcon,
      this.onSelected})
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
            onChanged: onSelected,
            fieldPrefixIcon: Icon(
              leftIcon,
              size: 25,
            ),
            errorText: error,
            errorStyle: TextStyle(fontSize: 15),
            hintText: title,
            searchText: 'ค้นหา',
            foundText: 'ไม่พบข้อมูล',
            hintStyle: TextStyle(color: Colors.grey.shade600),
            items: listItem,
            controller: controller,
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
