// ignore_for_file: prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_password.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/screen/main_screen/register_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert' as convert;

class Login_Page extends StatefulWidget {
  Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool loading = false;
  bool isAnimating = true;

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        setState(() {
          loading = true;
        });
        // เชื่อมต่อ api
        String url = '${Connect_api().domain}/login';
        var body = {
          "user_name": _username.text,
          "user_password": _password.text,
        };
        var response = await Dio().post(url,
            options: Options(headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            }),
            data: body);
        // เช็คการเชื่อมต่อ api
        if (response.statusCode == 200) {
          var jsonRes = LoginModel.fromJson(response.data);
          // เช็คสถานะ การเข้าสู่ระบบ
          print('body ${body}');
          if (jsonRes.status == 200) {
            await Future.delayed(const Duration(milliseconds: 600));
            var token = jsonRes.accessToken;
            List<User> data = jsonRes.user!; //ตัวแปร List จาก model

            print('userId: ${data.single.sId}');
            print('uuId: ${data.single.userUuid}');
            print('login success');
            print('token: ${token}');

            //ส่งค่าตัวแปร
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', token!);
            await prefs.setString('username', data.single.userName!);
            await prefs.setInt('role', data.single.mobile!);
            await prefs.setBool('security', false);

            if (data.single.userUuid != prefs.getString('uuId')) {
              await prefs.setString('userId', data.single.sId!);
              await prefs.setString('companyId', data.single.companyId!);
              await prefs.setString('uuId', data.single.userUuid!);
            }

            if (data.single.devicegroupUuid != null) {
              await prefs.setString('deviceId', data.single.devicegroupUuid!);
            }
            if (data.single.weigangroupUuid != null) {
              await prefs.setString('weiganId', data.single.weigangroupUuid!);
            }

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => BottomBar()));
            snackbar(context, Theme.of(context).primaryColor,
                'เข้าสู่ระบบสำเร็จ', Icons.check_circle_outline_rounded);

            setState(() {
              loading = false;
            });
          } else {
            await Future.delayed(const Duration(milliseconds: 600));
            print(jsonRes.data);
            print('username หรือ password ไม่ถูกต้อง');
            snackbar(context, Colors.red, 'ชื่อผู้ใช้ หรือ รหัสผ่าน ไม่ถูกต้อง',
                Icons.highlight_off_rounded);
            setState(() {
              loading = false;
            });
          }
        } else {
          await Future.delayed(const Duration(milliseconds: 600));
          print(response.statusCode);
          print('Connection Fail');
          snackbar(context, Colors.red, 'เข้าสู่ระบบไม่สำเร็จ',
              Icons.highlight_off_rounded);
          setState(() {
            loading = false;
          });
        }
      } catch (error) {
        await Future.delayed(Duration(milliseconds: 600));
        print(error);
        dialogOnebutton_Subtitle(
            context,
            'พบข้อผิดพลาด',
            'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
            Icons.warning_amber_rounded,
            Colors.orange,
            'ตกลง', () async {
          Navigator.of(context).pop();
        }, false, false);
        setState(() {
          loading = false;
        });
      }
    }
  }

  DateTime PressTime = DateTime.now();

  Future<bool> _onBackButtonDoubleClicked() async {
    int difference = DateTime.now().difference(PressTime).inMilliseconds;
    PressTime = DateTime.now();
    if (difference < 1500) {
      SystemNavigator.pop(animated: true);
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: const Text(
            "กดอีกครั้งเพื่อออก",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
          ),
          width: MediaQuery.of(context).size.width * 0.45,
          padding: const EdgeInsets.symmetric(vertical: 10),
          duration: const Duration(milliseconds: 1500),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInit = isAnimating || loading == false;
    return WillPopScope(
      onWillPop: () async => _onBackButtonDoubleClicked(),
      child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Smart Community Logo.png',
                    scale: 4,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text_Form(
                    controller: _username,
                    title: 'ชื่อผู้ใช้',
                    icon: Icons.account_circle_rounded,
                    error: 'กรุณากรอกชื่อผู้ใช้',
                    TypeInput: TextInputType.name,
                  ),
                  TextForm_Password(
                    controller: _password,
                    title: 'รหัสผ่าน',
                    iconLaft: Icons.key,
                    error: (values) {
                      if (values!.isEmpty) {
                        return 'กรุณากรอกรหัสผ่าน';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    onEnd: () => setState(() {
                      isAnimating = !isAnimating;
                    }),
                    width:
                        !loading ? MediaQuery.of(context).size.width * 0.5 : 70,
                    height: 45,
                    child: !isInit
                        ? Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Buttons(
                            title: 'เข้าสู่ระบบ',
                            press: () {
                              doLogin();
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Prompt',
                        ),
                        text: 'ยังไม่ได้เป็นสมาชิก HIP Smart Community ',
                        children: [
                          TextSpan(
                              text: 'กรุณาลงทะเบียน',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              Register_Page())));
                                })
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Divider(
                      thickness: 1,
                      color: Colors.black,
                    ),
                  ),
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Prompt',
                        ),
                        text: 'เข้าสู่ระบบใช้งาน ',
                        children: [
                          TextSpan(
                              text: 'พนักงาน',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, '/staff');
                                })
                        ],
                      ))
                ],
              )),
        ),
      ))),
    );
  }
}
