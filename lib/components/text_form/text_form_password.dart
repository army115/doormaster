import 'package:flutter/material.dart';

class TextForm_Password extends StatefulWidget {
  TextEditingController controller;
  String title;
  IconData iconLaft;
  var error;
  // bool redEye;
  // var iconRight;
  // var change;
  TextForm_Password({
    Key? key,
    required this.controller,
    required this.title,
    required this.iconLaft,
    required this.error,
    // required this.redEye,
    // required this.iconRight,
    // required this.change
  }) : super(key: key);

  @override
  State<TextForm_Password> createState() => _TextForm_PasswordState();
}

class _TextForm_PasswordState extends State<TextForm_Password> {
  bool redEye = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
          obscureText: redEye,
          style: TextStyle(fontSize: 18),
          controller: widget.controller,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            prefixIconColor: Colors.green,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            // labelText: 'Username',
            hintText: widget.title,
            hintStyle: TextStyle(fontSize: 18),
            errorStyle: TextStyle(fontSize: 16),
            // ignore: prefer_const_constructors
            prefixIcon: Icon(
              widget.iconLaft,
              size: 30,
            ),
            suffixIcon: widget.controller.text.length > 0
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        redEye = !redEye;
                      });
                    },
                    icon: redEye
                        ? Icon(
                            Icons.visibility_rounded,
                          )
                        : Icon(
                            Icons.visibility_off_rounded,
                          ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          onChanged: (text) {
            setState(() {});
          },
          validator: widget.error),
    );
  }
}
