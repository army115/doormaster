// ignore_for_file: prefer_const_constructors_in_immutables

import 'dart:convert';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/text_button.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_validator.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/register_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;

class Login_Page extends StatefulWidget {
  Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool loading = false;

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        // เชื่อมต่อ api
        String url = '${Connect_api().domain}/login';
        var body = {
          "email": _email.text,
          "password": _password.text,
        };
        var response = await http.post(Uri.parse(url), body: body);
        // เช็คการเชื่อมต่อ api
        if (response.statusCode == 200) {
          var jsonRes = LoginModel.fromJson(convert.jsonDecode(response.body));
          // เช็คสถานะ การเข้าสู่ระบบ
          if (jsonRes.status == 200) {
            setState(() {
              loading = true;
            });
            var token = jsonRes.token;
            List<User> data = jsonRes.user!; //ตัวแปร List จาก model

            print('userId: ${data.single.userId}');
            print('token: ${token}');
            print('login success');

            // ส่งค่าตัวแปร
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token!);
            await prefs.setInt('userId', data.single.userId!);
            await prefs.setInt('companyId', data.single.companyId!);
            await prefs.setInt('role', data.single.mobile!);

            if (data.single.devicegroupUuid != null) {
              await prefs.setString('deviceId', data.single.devicegroupUuid!);
            }

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Home_Page()));
            snackbar(context, Colors.indigo, 'เข้าสู่ระบบสำเร็จ', Icons.check);
            setState(() {
              loading = false;
            });
          } else {
            print(jsonRes.status);
            print('username หรือ password ไม่ถูกต้อง');
            snackbar(context, Colors.red, 'username หรือ password ไม่ถูกต้อง',
                Icons.close);
          }
        } else {
          print(response.statusCode);
          print('Connection Fail');
          snackbar(context, Colors.red, 'เชื่อมต่อไม่สำเร็จ', Icons.close);
        }
      } catch (error) {
        print(error);
        snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
            Icons.warning_amber_rounded);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text_Button(title: 'เข้าสู่ระบบ', press: () {}),
          Text_Button(
            title: 'ลงทะเบียน',
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
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo600.png',
                      scale: 2.5,
                    ),
                    Text_Form(
                      controller: _email,
                      title: 'ชื่อผู้ใช้',
                      icon: Icons.email,
                      error: 'กรุณากรอกชื่อผู้ใช้',
                    ),
                    TextForm_validator(
                        controller: _password,
                        title: 'รหัสผ่าน',
                        icon: Icons.key,
                        error: (values) {
                          if (values!.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          } else {
                            return null;
                          }
                        },
                        obscure: true),
                    SizedBox(
                      height: 20,
                    ),
                    loading
                        ? CircularProgressIndicator(
                            color: Colors.indigo,
                          )
                        : Buttons(
                            title: 'เข้าสู่ระบบ',
                            press: () {
                              doLogin();
                            },
                          ),
                    SizedBox(height: 20),
                    Text(
                      'ยังไม่ได้เป็นสมาชิก HIP QR Smart Access กรุณาลงทะเบียน',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

// class Login {
//   Login();

//   Future doLogin(String email, String password) async {
//     String url = 'http://119.59.97.193:7200/login';
//     var response = await http.post(Uri.parse(url));
//     var body = {
//       "email": email,
//       "password": password,
//     };

//     return http.post(Uri.parse(url), body: body);
//   }
// }
