// ignore_for_file: camel_case_types, must_be_immutable, unnecessary_null_comparison, unnecessary_null_in_if_null_operators

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Grid_Menu extends StatelessWidget {
  String title;
  VoidCallback? press;
  final icon;
  final color;
  final textColor;
  final type;
  Grid_Menu(
      {Key? key,
      required this.title,
      required this.press,
      required this.icon,
      this.color,
      this.textColor,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      color: color ?? Theme.of(context).primaryColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        onTap: press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
                type == null
                    ? icon
                    : type == 'cuper'
                        ? IconData(int.parse(icon),
                            fontFamily: CupertinoIcons.iconFont,
                            fontPackage: CupertinoIcons.iconFontPackage)
                        : IconData(int.parse(icon),
                            fontFamily: 'MaterialIcons'),
                size: 45,
                color: Colors.white),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: textColor ?? Colors.white,
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
