import 'package:flutter/material.dart';

class ImageLoading extends StatelessWidget {
  const ImageLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 120,
      width: 120,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.zero,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    ));
  }
}
