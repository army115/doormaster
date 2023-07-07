import 'package:flutter/material.dart';

class TextForm_Null extends StatelessWidget {
  final title;
  final errortext;
  final iconleft;
  final iconright;
  const TextForm_Null(
      {super.key, this.title, this.errortext, this.iconleft, this.iconright});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        elevation: 10,
        child: TextFormField(
          readOnly: true,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: title,
              hintStyle: TextStyle(fontSize: 16),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 13, horizontal: 10),
              errorStyle: TextStyle(fontSize: 15),
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
