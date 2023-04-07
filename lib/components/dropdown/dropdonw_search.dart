import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class Dropdown_Search extends StatelessWidget {
  String title;
  TextEditingController controller;
  List listItem;
  String error;
  // final onSelected;
  // double width;
  // double height;
  Dropdown_Search({
    Key? key,
    required this.title,
    required this.controller,
    required this.listItem,
    // required this.width,
    // required this.height,
    required this.error,
    // this.onSelected
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
          borderRadius: BorderRadius.circular(10),
          elevation: 10,
          color: Colors.white,
          child: CustomDropdown.search(
            errorText: error,
            hintText: title,
            items: ['sdf', 'asda'],
            // listItemBuilder: listItem,
            controller: controller,
          )
          // DropdownMenu(
          //   initialSelection: values,
          //   textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          //   menuStyle: MenuStyle(
          //       visualDensity: VisualDensity.compact,
          //       padding: MaterialStateProperty.all(EdgeInsets.zero),
          //       elevation: MaterialStateProperty.all(10),
          //       backgroundColor: MaterialStateProperty.all(Colors.white)),
          //   width: MediaQuery.of(context).size.width * 0.9,
          //   menuHeight: height,
          //   enableFilter: true,
          //   enableSearch: true,
          //   hintText: title,
          //   selectedTrailingIcon: Text('asdasd'),
          //   leadingIcon: Icon(leftIcon),
          //   trailingIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          //   dropdownMenuEntries: listItem,
          //   inputDecorationTheme: InputDecorationTheme(
          //     hintStyle: TextStyle(fontSize: 16),
          //     focusedBorder: OutlineInputBorder(
          //       borderSide:
          //           BorderSide(color: Theme.of(context).primaryColor, width: 2),
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     enabledBorder: OutlineInputBorder(
          //       borderSide: BorderSide.none,
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     focusedErrorBorder: OutlineInputBorder(
          //       borderSide: BorderSide(color: Colors.red, width: 2),
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     errorBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(color: Colors.red, width: 2),
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
          //     errorStyle: TextStyle(fontSize: 15),
          //   ),
          //   onSelected: onSelected,
          // ),
          ),
    );
  }
}
