// ignore_for_file: camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class Grid_Menu extends StatelessWidget {
  String title;
  VoidCallback press;
  final icon;
  Grid_Menu(
      {Key? key, required this.title, required this.press, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // borderRadius: BorderRadius.circular(20),
      elevation: 10,
      color: Theme.of(context).primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        onTap: press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40, color: Colors.white),
            // SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
