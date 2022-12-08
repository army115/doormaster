import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/text_button.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/register_page.dart';
import 'package:flutter/material.dart';

class Login_Page extends StatefulWidget {
  Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

class _Login_PageState extends State<Login_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text_Button(title: 'Login', press: () {}),
          Text_Button(
            title: 'Register',
            press: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => Register_Page())));
            },
          )
        ],
      ),
      appBar: AppBar(
        title: Text('เข้าสู่ระบบ'),
      ),
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text_Form(
                  controller: email,
                  title: 'email',
                  icon: Icon(Icons.email),
                ),
                Text_Form(
                    controller: password,
                    title: 'password',
                    icon: Icon(Icons.key)),
                SizedBox(
                  height: 20,
                ),
                Buttons(
                  title: 'Login',
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => Home_Page())));
                  },
                ),
                SizedBox(height: 20),
                Text('ยังไม่ได้เป็นสมาชิก HIP QR Smart Access กรุณาลงทะเบียน'),
              ],
            )),
      ),
    );
  }
}
