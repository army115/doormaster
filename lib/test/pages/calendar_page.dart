import 'package:doormster/screen/qr_smart_access/qr_smart_home_page.dart';
import 'package:flutter/material.dart';

import '../screens/screen2.dart';

class CalendarPage extends StatelessWidget {
  final onNext;

  CalendarPage({this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: FlatButton(
          // onPressed: onNext,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QRSmart_HomePage()));
          },
          child: Text('Go to next screen'),
          color: Colors.white,
        ),
      ),
    );
  }
}
