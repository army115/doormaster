import 'package:flutter/material.dart';

class Logo_Opacity extends StatelessWidget {
  const Logo_Opacity({Key? key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          Image.asset('assets/images/Smart Community Logo.png', scale: 5),
          Text(
            'ไม่มีข้อมูลที่บันทึก',
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
