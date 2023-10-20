// ignore_for_file: prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements, avoid_print, use_build_context_synchronously, unused_local_variable, unused_import
import 'dart:developer';

import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/button_animation.dart';
import 'package:doormster/components/snackbar/back_double.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_password.dart';
import 'package:doormster/controller/back_double.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/screen/main_screen/register_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  bool remember = false;

  Future doLogin() async {
    if (_formkey.currentState!.validate()) {
      try {
        await Future.delayed(const Duration(milliseconds: 600));
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
            var token = jsonRes.accessToken;
            List<User> data = jsonRes.user!; //ตัวแปร List จาก model

            print('userId: ${data.single.sId}');
            print('uuId: ${data.single.userUuid}');
            print('login success');
            print('token: ${token}');
            if (data.single.block == 0 || data.single.block == null) {
              //ส่งค่าตัวแปร
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token!);
              await prefs.setString('username', data.single.userName!);
              await prefs.setString('password', _password.text);
              await prefs.setString('fname', data.single.firstName!);
              await prefs.setString('lname', data.single.surName!);
              await prefs.setInt('role', data.single.mobile!);
              await prefs.setBool('security', false);

              if (data.single.image != null) {
                await prefs.setString('image', data.single.image!);
              }

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

              //บันทึก deviece token ลง database
              Notify_Token()
                  .create_notifyToken(data.single.companyId, data.single.sId);

              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BottomBar()));
              bottomController.ontapItem(0);
              snackbar(context, Theme.of(context).primaryColor,
                  'login_success'.tr, Icons.check_circle_outline_rounded);
            } else {
              print('account block');
              dialogOnebutton_Subtitle(
                  context,
                  'account_block'.tr,
                  'unblock_account'.tr,
                  Icons.warning_amber_rounded,
                  Colors.orange,
                  'ok'.tr, () async {
                Navigator.of(context).pop();
              }, false, false);
              setState(() {
                loading = false;
              });
            }
          } else {
            print(jsonRes.data);
            print('ชื่อผู้ใช้ หรือ รหัสผ่าน ไม่ถูกต้อง');
            snackbar(context, Colors.red, 'wrong_username'.tr,
                Icons.highlight_off_rounded);
            setState(() {
              loading = false;
            });
          }
        } else {
          print(response.statusCode);
          print('Connection Fail');
          snackbar(context, Colors.red, 'login_failed'.tr,
              Icons.highlight_off_rounded);
          setState(() {
            loading = false;
          });
        }
      } catch (error) {
        print(error);
        error_connected(context, () async {
          Navigator.of(context).pop();
        });
        setState(() {
          loading = false;
        });
      }
    }
  }

  void _Rememberme(bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember", value!);
    setState(() {
      remember = value;
      print('remember : $remember');
    });
  }

  void _loadUsernamePassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString("username");
      var password = prefs.getString("password");
      var remeberMe = prefs.getBool("remember") ?? false;
      log(remeberMe.toString());
      if (remeberMe) {
        setState(() {
          remember = true;
        });

        _username.text = username!;
        _password.text = password!;
      }
      print('remember : $remember');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _loadUsernamePassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onBackButtonDoubleClicked(context),
      child: Scaffold(
          // backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
        child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Container(
                  // height: MediaQuery.of(context).size.height * 0.7,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/Smart Community Logo.png',
                        scale: 3.5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text_Form(
                        controller: _username,
                        title: 'username'.tr,
                        icon: Icons.account_circle_rounded,
                        error: 'enter_username_pls'.tr,
                        TypeInput: TextInputType.name,
                      ),
                      TextForm_Password(
                        controller: _password,
                        title: 'password'.tr,
                        iconLaft: Icons.key,
                        error: (values) {
                          if (values!.isEmpty) {
                            return 'enter_password_pls'.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('remember'.tr),
                        activeColor: Theme.of(context).primaryColor,
                        value: remember,
                        onChanged: _Rememberme,
                        controlAffinity: ListTileControlAffinity
                            .leading, // Checkbox position
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         Checkbox(
                      //             activeColor: Theme.of(context).primaryColor,
                      //             value: remember,
                      //             onChanged: _Rememberme),
                      //         Text(
                      //           'บันทึกรหัสผ่าน',
                      //         )
                      //       ],
                      //     ),
                      //     TextButton(
                      //         style: const ButtonStyle(
                      //             overlayColor: MaterialStatePropertyAll(
                      //                 Colors.transparent)),
                      //         onPressed: () {},
                      //         child: const Text(
                      //           'ลืมรหัสผ่าน',
                      //           style: TextStyle(
                      //             decoration: TextDecoration.underline,
                      //             fontWeight: FontWeight.normal,
                      //             fontSize: 16,
                      //           ),
                      //         ))
                      //   ],
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                      Button_Animation(
                        title: 'login'.tr,
                        press: () async {
                          await doLogin();
                        },
                      ),
                      const SizedBox(height: 20),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 19,
                              letterSpacing: 0.5,
                              color: Colors.black,
                              fontFamily: 'Prompt',
                            ),
                            text: 'no_account'.tr,
                            children: [
                              TextSpan(
                                  text: 'register'.tr,
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
                              fontSize: 19,
                              letterSpacing: 0.5,
                              color: Colors.black,
                              fontFamily: 'Prompt',
                            ),
                            text: 'login_for'.tr,
                            children: [
                              TextSpan(
                                  text: 'employee'.tr,
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
            )),
      )),
    );
  }
}
