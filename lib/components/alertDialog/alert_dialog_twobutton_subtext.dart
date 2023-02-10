import 'package:flutter/material.dart';

void dialogTwobutton_Subtitle(
  context,
  title,
  subtitle,
  icon,
  coloricon,
  button1,
  press1,
  button2,
  press2,
  click,
) {
  showDialog(
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 5,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          button1,
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: press1,
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        elevation: 5,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          button2,
                          style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: press2,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ));
}
