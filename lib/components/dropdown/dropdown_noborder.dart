import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

// class Dropdown_NoBorder extends StatelessWidget {
//   final title;
//   var values;
//   final listItem;
//   final leftIcon;
//   final validate;
//   final onChange;
//   Dropdown_NoBorder(
//       {Key? key,
//       this.title,
//       this.values,
//       this.listItem,
//       this.leftIcon,
//       this.validate,
//       this.onChange})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: DropdownButtonFormField(
//           hint: Text(title),
//           style: TextStyle(
//               fontSize: 16,
//               fontFamily: 'Prompt',
//               color: Colors.black,
//               height: 1.2),
//           decoration: InputDecoration(
//             hintText: title,
//             hintStyle: TextStyle(fontSize: 16),
//             prefixIcon: Icon(
//               leftIcon,
//               size: 25,
//             ),
//             // border: InputBorder.none,
//             // border: OutlineInputBorder(
//             //   borderRadius: BorderRadius.circular(10.0),
//             // ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
//             errorStyle: TextStyle(fontSize: 15),
//           ),
//           value: values,
//           icon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
//           items: listItem,
//           onChanged: onChange,
//           validator: validate),
//     );
//   }
// }

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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: CustomDropdown(
        excludeSelected: controller.text == null ? false : true,
        hideSelectedFieldWhenOpen: false,
        onChanged: onChanged,
        items: listItem,
        controller: controller,
        fillColor: Colors.grey.shade200,
        fieldPrefixIcon: Icon(
          leftIcon,
          size: 25,
        ),
        errorText: error,
        errorStyle: TextStyle(fontSize: 15),
        hintText: title,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        searchText: 'ค้นหา',
        foundText: 'ไม่พบข้อมูล',
        borderRadiusItem: BorderRadius.circular(5),
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 13),
      ),
    );
  }
}
