// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      padding: EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 3,
        color: Colors.white,
        child: TextFormField(
            obscureText: redEye,
            style: TextStyle(fontSize: 16),
            controller: widget.controller,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10, vertical: 13),
              // labelText: 'Username',
              hintText: widget.title,
              hintStyle: TextStyle(fontSize: 16),
              errorStyle: TextStyle(fontSize: 15),
              // ignore: prefer_const_constructors
              prefixIcon: Icon(
                widget.iconLaft,
                size: 25,
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
                              Icons.visibility_off,
                            )
                          : Icon(
                              Icons.visibility,
                            ),
                    )
                  : null,
              // filled: true, พื้นหลังช่อง
              // fillColor: Colors.white,
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
            onChanged: (text) {
              setState(() {});
            },
            validator: widget.error),
      ),
    );
  }
}
