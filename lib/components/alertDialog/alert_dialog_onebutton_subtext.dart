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
  willpop,
) {
  showDialog(
      useRootNavigator: true,
      barrierDismissible: click,
      context: context,
      builder: (_) => WillPopScope(
            onWillPop: (() async => willpop),
            child: Center(
              child: SingleChildScrollView(
                child: AlertDialog(
                  titlePadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                fontSize: 16,
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
                ),
              ),
            ),
          ));
}

Widget dialogmain(title, subtitle, icon, coloricon, button, press) {
  return AlertDialog(
    titlePadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
          width: double.infinity,
          child: RaisedButton(
            padding: EdgeInsets.symmetric(vertical: 5),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 5,
            color: Color(0xFF0B4D9C),
            child: Text(
              button,
              style: TextStyle(
                  fontSize: 16,
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
  );
}
