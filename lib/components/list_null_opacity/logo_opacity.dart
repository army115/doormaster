// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Logo_Opacity extends StatelessWidget {
  String title;
  Logo_Opacity({Key? key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/Smart Community Logo.png', scale: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
