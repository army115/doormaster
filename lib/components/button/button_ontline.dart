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
      child: OutlinedButton(
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.black26),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              side: MaterialStateProperty.all(
                  BorderSide(color: Colors.white, width: 1))),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
            ),
          ),
          onPressed: press),
    );
  }
}
