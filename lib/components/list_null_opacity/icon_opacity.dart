import 'package:flutter/material.dart';

class Icon_Opacity extends StatelessWidget {
  String title;
  Icon_Opacity({Key? key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 100,
            ),
            Text(
              'ไม่มีเมนูที่คุณใช้งานได้\nโปรดติดต่อผู้ดูแล',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
