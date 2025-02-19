import 'package:doormster/style/textStyle.dart';
import 'package:flutter/material.dart';

class Advert_Page extends StatefulWidget {
  const Advert_Page({super.key});

  @override
  State<Advert_Page> createState() => _Advert_PageState();
}

class _Advert_PageState extends State<Advert_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                'HIP เครื่องสแกนลายนิ้วมือ รุ่น CMiF35U',
                style: textStyle.title16,
              ),
              const Divider(
                thickness: 1,
              ),
              const Image(
                  image: NetworkImage(
                      'https://www.hip.co.th/wp-content/uploads/2024/04/Face-Scan-And-Fingerprint_CMiF35U_4.webp')),
              const SizedBox(height: 10),
              Text(
                "HIP Fingerprint Time and Access Control รุ่น CMiF35Uเครื่องสแกนลายนิ้วมือ ทาบบัตร รองรับผู้ใช้สูงสุด 3,000 ผู้ใช้ สำหรับบันทึกเวลาเข้างาน และควบคุมการเข้า-ออกประตู ใช้งานร่วมกับโปรแกรมบริหารจัดการเวลาพนักงาน Premium time Series U และ ezLINE สแกนส่งไลน์ทันทีแบบไม่ต้องเปิดโปรแกรมทิ้งไว้ ฟรี!!..ไม่มีค่าบริการ",
                style: textStyle.body14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
