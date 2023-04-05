import 'package:flutter/material.dart';

class Dropdown_Search extends StatelessWidget {
  final title;
  var values;
  List<DropdownMenuEntry<String?>> listItem;
  final leftIcon;
  // final validate;
  final onSelected;
  double width;
  double height;
  Dropdown_Search(
      {Key? key,
      this.title,
      this.values,
      required this.listItem,
      required this.width,
      required this.height,
      this.leftIcon,
      // this.validate,
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
        child: DropdownMenu(
          initialSelection: values,
          textStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
          menuStyle: MenuStyle(
              visualDensity: VisualDensity.compact,
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              elevation: MaterialStateProperty.all(10),
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          width: MediaQuery.of(context).size.width * width,
          menuHeight: height,
          enableFilter: true,
          enableSearch: true,
          hintText: title,
          selectedTrailingIcon: Text('asdasd'),
          leadingIcon: Icon(leftIcon),
          trailingIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          dropdownMenuEntries: listItem,
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(fontSize: 16),
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
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            errorStyle: TextStyle(fontSize: 15),
          ),
          onSelected: onSelected,
        ),
      ),
    );
  }
}
