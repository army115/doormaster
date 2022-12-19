import 'package:doormster/screen/register_page.dart';
import 'package:flutter/material.dart';

class Text_Button extends StatelessWidget {
  String title;
  VoidCallback press;
  Text_Button({Key? key, required this.title, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        // style: TextButton.styleFrom(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(0),
        //     ),
        //     primary: Colors.white,
        //     backgroundColor: Colors.indigo),
        onPressed: press,
        child: Text(
          title,
          style: TextStyle(fontSize: 25),
        ));
  }
}
