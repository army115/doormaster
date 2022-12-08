import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/screen/contact_detail_page.dart';
import 'package:flutter/material.dart';

class Contact_Page extends StatefulWidget {
  Contact_Page({Key? key}) : super(key: key);

  @override
  State<Contact_Page> createState() => _Contact_PageState();
}

final _kye = GlobalKey<FormState>();
final name = TextEditingController();
final codeId = TextEditingController();
final phone = TextEditingController();
final location = TextEditingController();
final date = TextEditingController();
final controller = TextEditingController();

class _Contact_PageState extends State<Contact_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนล่วงหน้าผู้มาติดต่อ')),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _kye,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text_Form(
                      controller: name,
                      title: 'ชื่อ-สกุล',
                      icon: Icon(Icons.person),
                    ),
                    Text_Form(
                      controller: codeId,
                      title: 'เลขบัตรประชาชน',
                      icon: Icon(Icons.person),
                    ),
                    Text_Form(
                      controller: phone,
                      title: 'เบอร์โทร',
                      icon: Icon(Icons.person),
                    ),
                    Text_Form(
                      controller: location,
                      title: 'ติดต่อที่',
                      icon: Icon(Icons.person),
                    ),
                    Text_Form(
                      controller: date,
                      title: 'วัน เวลา',
                      icon: Icon(Icons.person),
                    ),
                    Buttons(
                        title: 'สร้าง QR Code',
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Contact_Detail(
                                        texts: [
                                          'ชื่อ: ${name.text}',
                                          'รหัสบัตรประชาชน: ${codeId.text}',
                                          'เบอร์โทร: ${phone.text}',
                                          'ติดต่อที่: ${location.text}',
                                          'วันที่ เวลา: ${date.text}',
                                        ],
                                        name: 'ชื่อ: ${name.text}',
                                        codeId:
                                            'รหัสบัตรประชาชน: ${codeId.text}',
                                        phone: 'เบอร์โทร: ${phone.text}',
                                        location: 'ติดต่อที่: ${location.text}',
                                        date: 'วันที่ เวลา: ${date.text}',
                                      )));
                        }),

                    // Container(
                    //   margin: EdgeInsets.all(20),
                    //   child: TextField(
                    //     controller: controller,
                    //     decoration: InputDecoration(
                    //         border: OutlineInputBorder(),
                    //         labelText: 'Enter URL'),
                    //   ),
                    // ),
                    // ElevatedButton(
                    //     onPressed: () {
                    //       setState(() {});
                    //     },
                    //     child: Text('GENERATE QR')),
                  ]),
            ),
          ),
        ),
      )),
    );
  }
}
