import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  String title;
  VoidCallback press;
  Buttons({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
          child: Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          onPressed: press),
    );
  }
}
