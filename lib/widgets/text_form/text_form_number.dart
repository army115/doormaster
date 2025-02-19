// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:doormster/style/textStyle.dart';

class TextForm_Number extends StatelessWidget {
  final TextEditingController controller;
  final String? title;
  final IconData? icon;
  final error;
  final int? maxLength;
  final TextInputType? type;
  final GlobalKey fieldKey;
  TextForm_Number(
      {Key? key,
      required this.controller,
      this.title,
      this.icon,
      this.error,
      this.type,
      this.maxLength,
      required this.fieldKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: TextFormField(
            key: fieldKey,
            onTap: () => scrollToField(fieldKey),
            style: textStyle.title16,
            controller: controller,
            maxLength: maxLength,
            keyboardType: type,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              // counterText: '',
              counterStyle: const TextStyle(fontSize: 14),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              // labelText: 'Username',
              hintText: title,
              hintStyle: textStyle.title16,
              errorStyle: textStyle.body14,
              prefixIcon: icon == null
                  ? null
                  : Icon(
                      icon,
                      size: 25,
                    ),
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
            validator: error),
      ),
    );
  }
}
