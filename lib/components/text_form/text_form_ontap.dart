import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextForm_Ontap extends StatelessWidget {
  final title;
  final errortext;
  final iconleft;
  final iconright;
  final ontap;
  final controller;
  const TextForm_Ontap(
      {super.key,
      this.title,
      this.errortext,
      this.iconleft,
      this.iconright,
      this.ontap,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        elevation: 3,
        child: TextFormField(
          minLines: 1,
          maxLines: 5,
          controller: controller,
          readOnly: true,
          style: textStyle().title16,
          onTap: ontap,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: title,
              hintStyle: textStyle().title16,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              errorStyle: textStyle().body14,
              prefixIcon: Icon(
                iconleft,
              ),
              suffixIcon: Icon(
                iconright,
                size: 30,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Get.theme.primaryColor, width: 2),
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
              )),
          validator: (value) {
            if (value!.isEmpty) {
              return errortext;
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }
}
