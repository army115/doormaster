import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';

class DropdownNormol extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final IconData? leftIcon;
  final String? error;
  final onChanged;
  final List listItem;
  final GlobalKey? fieldKey;
  const DropdownNormol(
      {super.key,
      required this.title,
      this.controller,
      this.leftIcon,
      this.error,
      required this.onChanged,
      required this.listItem,
      this.fieldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: DropdownButtonFormField(
          hint: Text(title),
          key: fieldKey,
          menuMaxHeight: 200,
          items: listItem.map(
            (item) {
              return DropdownMenuItem(
                value: item,
                child: Text(item.label),
              );
            },
          ).toList(),
          onTap: () => scrollToField(fieldKey!),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return " $error";
            } else {
              return null;
            }
          },
          icon: Container(),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            hintText: title,
            hintStyle: textStyle.title16,
            errorStyle: textStyle.body14,
            prefixIcon: leftIcon == null ? null : Icon(leftIcon, size: 25),
            suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, size: 25),
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
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
