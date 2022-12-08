import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:flutter/material.dart';

class Register_Page extends StatefulWidget {
  Register_Page({Key? key}) : super(key: key);

  @override
  State<Register_Page> createState() => _Register_PageState();
}

TextEditingController username = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController passwordCon = TextEditingController();

bool Checked = false;

class _Register_PageState extends State<Register_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงทะเบียน'),
      ),
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text_Form(
                  controller: username,
                  title: 'ชื่อผู้ใช้',
                  icon: Icon(Icons.person)),
              Text_Form(
                  controller: phone,
                  title: 'เบอร์โทรติดต่อ',
                  icon: Icon(Icons.person)),
              Text_Form(
                  controller: address,
                  title: 'บ้านเลขที่',
                  icon: Icon(Icons.person)),
              Text_Form(
                  controller: password,
                  title: 'รหัสผ่าน',
                  icon: Icon(Icons.person)),
              Text_Form(
                  controller: passwordCon,
                  title: 'ยืนยันรหัสผ่าน',
                  icon: Icon(Icons.person)),
              Row(
                children: [
                  Checkbox(
                    value: Checked,
                    onChanged: (bool? value) {
                      setState(() {
                        Checked = value!;
                      });
                    },
                  ),
                  Text('ยอมรับเงื่อนไขการใช้บริการ')
                ],
              ),
              Buttons(
                title: 'ลงทะเบียน',
                press: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Home_Page())));
                },
              )
            ]),
          ),
        ),
      )),
    );
  }
}
