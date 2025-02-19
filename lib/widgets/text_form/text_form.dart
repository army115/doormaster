// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'dart:ffi';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:get/get.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';

class Text_Form extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final IconData? icon;
  final String? error;
  final TextInputType? TypeInput;
  final int? minLines;
  final int? maxLines;
  final GlobalKey fieldKey;
  const Text_Form(
      {Key? key,
      required this.controller,
      this.title,
      this.icon,
      this.error,
      this.TypeInput,
      this.minLines,
      this.maxLines,
      required this.fieldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: TextFormField(
          onTap: () => scrollToField(fieldKey),
          key: fieldKey,
          autofocus: false,
          style: textStyle.title16,
          controller: controller,
          keyboardType: TypeInput,
          minLines: minLines ?? 1,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            hintText: title,
            hintStyle: textStyle.title16,
            errorStyle: textStyle.body14,
            prefixIcon: icon == null ? null : Icon(icon, size: 25),
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
          ),
          validator: (values) {
            if (values!.isEmpty) {
              return error;
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}
