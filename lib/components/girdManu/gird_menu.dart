import 'package:flutter/material.dart';

class Gird_Menu extends StatelessWidget {
  String title;
  VoidCallback press;
  final icon;
  Gird_Menu(
      {Key? key, required this.title, required this.press, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Card(
        elevation: 5,
        color: Colors.indigo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset(
            //   //รูปภาพ
            //   img,
            //   width: 80,
            // ),
            Icon(icon, size: 50, color: Colors.white),
            // SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
