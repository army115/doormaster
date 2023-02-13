import 'package:flutter/material.dart';

void dialogOnebutton_Subtitle(
  context,
  title,
  subtitle,
  icon,
  coloricon,
  button,
  press,
  click,
) {
  showDialog(
      useRootNavigator: false,
      barrierDismissible: click,
      context: context,
      builder: (_) => AlertDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Column(
              children: [
                Icon(
                  icon,
                  size: 60,
                  color: coloricon,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    elevation: 5,
                    color: Theme.of(context).primaryColor,
                    child: Text(
                      button,
                      style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: press,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ));
}
