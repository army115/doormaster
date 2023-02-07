import 'package:flutter/material.dart';

class Buttons_Outline extends StatelessWidget {
  String title;
  VoidCallback press;
  Buttons_Outline({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 45,
      child: OutlineButton(
          highlightedBorderColor: Colors.white,
          borderSide: BorderSide(width: 1, color: Colors.white),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.transparent,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
            ),
          ),
          onPressed: press),
    );
  }
}
