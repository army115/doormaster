// ignore_for_file: prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements, avoid_print, use_build_context_synchronously, unused_local_variable
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button_animation.dart';
import 'package:doormster/components/snackbar/back_double.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_password.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert' as convert;

class Login_Staff extends StatefulWidget {
  Login_Staff({Key? key}) : super(key: key);

  @override
  State<Login_Staff> createState() => _Login_StaffState();
}

class _Login_StaffState extends State<Login_Staff> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool loading = false;
  bool isAnimating = true;

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        await Future.delayed(const Duration(milliseconds: 600));
        setState(() {
          loading = true;
        });
        // เชื่อมต่อ api
        String url = '${Connect_api().domain}/loginsecurity';
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
          print('error ${jsonRes.status}');
          print('body ${body}');
          if (jsonRes.status == 200) {
            var token = jsonRes.accessToken;
            List<User> data = jsonRes.user!; //ตัวแปร List จาก model

            print('userId: ${data.single.sId}');
            print('uuId: ${data.single.userUuid}');
            print('login success');
            print('token: ${token}');

            if (data.single.block == 0) {
              // ส่งค่าตัวแปร
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token!);
              await prefs.setString('username', data.single.userName!);
              await prefs.setString('fname', data.single.firstName!);
              await prefs.setString('lname', data.single.surName!);
              await prefs.setString('userId', data.single.sId!);
              await prefs.setString('companyId', data.single.companyId!);
              await prefs.setString('uuId', data.single.userUuid!);
              await prefs.setBool('security', data.single.isSecurity!);
              if (data.single.image != null) {
                await prefs.setString('image', data.single.image!);
              }
              print(data.single.isSecurity);

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BottomBar()));
              snackbar(context, Theme.of(context).primaryColor,
                  'เข้าสู่ระบบสำเร็จ', Icons.check_circle_outline_rounded);

              // setState(() {
              //   loading = false;
              // });
            } else {
              print(jsonRes.data);
              print('username หรือ password ไม่ถูกต้อง');
              snackbar(
                  context,
                  Colors.red,
                  'ชื่อผู้ใช้ หรือ รหัสผ่าน ไม่ถูกต้อง',
                  Icons.highlight_off_rounded);
              setState(() {
                loading = false;
              });
            }
          } else {
            print(jsonRes.data);
            print('username หรือ password ไม่ถูกต้อง');
            snackbar(context, Colors.red, 'ชื่อผู้ใช้ หรือ รหัสผ่าน ไม่ถูกต้อง',
                Icons.highlight_off_rounded);
            setState(() {
              loading = false;
            });
          }
        } else {
          print(response.statusCode);
          print('Connection Fail');
          snackbar(context, Colors.red, 'เข้าสู่ระบบไม่สำเร็จ',
              Icons.highlight_off_rounded);
          setState(() {
            loading = false;
          });
        }
      } catch (error) {
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
      backDouble(context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isInit = isAnimating || loading == false;

    return WillPopScope(
      onWillPop: () async => _onBackButtonDoubleClicked(),
      child: Scaffold(
          // backgroundColor: Theme.of(context).primaryColor,
          body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Stack(
            children: [
              PhysicalModel(
                // borderRadius: BorderRadius.circular(10),
                elevation: 10,
                color: Theme.of(context).primaryColor,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.55,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Smart Logo White.png',
                      scale: 3.5,
                    ),
                    Text(
                      'เข้าสู่ระบบใช้งาน สำหรับพนักงาน',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PhysicalModel(
                      borderRadius: BorderRadius.circular(10),
                      elevation: 10,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
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
                            SizedBox(
                              height: 15,
                            ),
                            // AnimatedContainer(
                            //   duration: const Duration(milliseconds: 200),
                            //   onEnd: () => setState(() {
                            //     isAnimating = !isAnimating;
                            //   }),
                            //   width: !loading
                            //       ? MediaQuery.of(context).size.width * 0.5
                            //       : 70,
                            //   height: 45,
                            //   child: !isInit
                            //       ? Container(
                            //           decoration: BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color:
                            //                   Theme.of(context).primaryColor),
                            //           child: const Center(
                            //             child: CircularProgressIndicator(
                            //               color: Colors.white,
                            //             ),
                            //           ),
                            //         )
                            //       : Buttons(
                            //           title: 'เข้าสู่ระบบ',
                            //           press: () {
                            //             doLogin();
                            //           },
                            //         ),
                            // ),
                            // SizedBox(
                            //   height: 20,
                            // ),
                            Button_Animation(
                              title: 'เข้าสู่ระบบ',
                              press: () async {
                                await doLogin();
                              },
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, bottom: 10),
                              child: Divider(
                                thickness: 1,
                                color: Colors.black,
                              ),
                            ),
                            RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 19,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                    fontFamily: 'Prompt',
                                  ),
                                  text: 'เข้าสู่ระบบใช้งาน ',
                                  children: [
                                    TextSpan(
                                        text: 'ผู้ใช้ทั่วไป',
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushReplacementNamed(
                                                context, '/login');
                                          })
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget btnSubmit(String title, VoidCallback press) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 45,
      child: ElevatedButton(
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 10,
              // shadowColor: Colors.white,
              primary: Colors.black,
              backgroundColor: Colors.white),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
              letterSpacing: 1,
            ),
          ),
          onPressed: press),
    );
  }
}
