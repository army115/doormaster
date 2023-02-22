import 'package:flutter/material.dart';

void dialogTwobutton(
  context,
  title,
  icon,
  coloricon,
  button1,
  press1,
  button2,
  press2,
  click,
  willpop,
) {
  showDialog(
      useRootNavigator: true,
      barrierDismissible: click,
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: () async => willpop,
            child: AlertDialog(
              titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Column(
                children: [
                  Icon(
                    icon,
                    size: 60,
                    color: coloricon,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RaisedButton(
                          padding: EdgeInsets.all(5),
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
                          padding: EdgeInsets.all(5),
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
                    height: 10,
                  ),
                ],
              ),
            ),
          ));
}
