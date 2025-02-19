import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';

class TextForm_Null extends StatelessWidget {
  final title;
  final errortext;
  final iconleft;
  final iconright;
  final GlobalKey fieldKey;
  const TextForm_Null(
      {super.key,
      this.title,
      this.errortext,
      this.iconleft,
      this.iconright,
      required this.fieldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
        elevation: 3,
        child: TextFormField(
          readOnly: true,
          style: textStyle.title16,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: title,
              hintStyle: textStyle.title16,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              errorStyle: textStyle.body14,
              prefixIcon: Icon(
                iconleft,
                color: Colors.grey.shade600,
              ),
              suffixIcon: Icon(
                iconright,
                color: Colors.grey.shade600,
                size: 30,
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
