// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

class Password_Page extends StatefulWidget {
  final userpass;

  Password_Page({Key? key, this.userpass}) : super(key: key);

  @override
  State<Password_Page> createState() => _Password_PageState();
}

class _Password_PageState extends State<Password_Page> {
  final _formkey = GlobalKey<FormState>();
  final _oldpass = TextEditingController();
  final _newpass = TextEditingController();
  final _conpass = TextEditingController();

  var confirmPass;
  var token;
  var username;
  bool loading = false;

  bool redEyeold = true;
  bool redEyenew = true;
  bool redEyecon = true;
  late SharedPreferences prefs;

  Future<void> _getUsername() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    username = prefs.getString('username');
    print(username);
  }

  Future<void> _changePassword(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      String url = '${Connect_api().domain}/changpassword';
      var jsonRes = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);
      var _response = jsonRes.toString().split(',').first.split(':').last;
      print(_response);
      if (_response != '400') {
        print('Change Success!');
        await prefs.setBool("remember", false);
        Get.until((route) => route.isFirst);
        bottomController.ontapItem(0);
        snackbar(context, Theme.of(context).primaryColor, 'password_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        print('Change Fail!!');
        dialogOnebutton_Subtitle(context, 'found_error'.tr, 'wrong_password'.tr,
            Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
          Navigator.of(context).pop();
        }, false, false);
      }
    } catch (error) {
      print(error);
      error_connected(context, () async {
        Navigator.of(context).pop();
      });
      // snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
      //     Icons.warning_amber_rounded);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('change_password'.tr),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              // รหัสผ่านปัจจุบัน*****************************************************************************
              textpass(
                _oldpass,
                redEyeold,
                'current_password'.tr,
                Icon(
                  Icons.lock_open_rounded,
                  size: 30,
                ),
                () => setState(() {
                  redEyeold = !redEyeold;
                }),
                (values) {
                  if (values!.isEmpty) {
                    return 'enter_password_current'.tr;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              // รหัสผ่านใหม่*****************************************************************************
              textpass(
                _newpass,
                redEyenew,
                'new_password'.tr,
                Icon(Icons.key_rounded, size: 30),
                () => setState(() {
                  redEyenew = !redEyenew;
                }),
                (values) {
                  confirmPass = values;
                  if (values.isEmpty) {
                    return 'enter_password_pls'.tr;
                  } else if (values == widget.userpass) {
                    return "same_password".tr;
                  } else if (values.length < 8) {
                    return "password_8char".tr;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              // ยืนยันรหัสผ่าน*****************************************************************************
              textpass(
                _conpass,
                redEyecon,
                'confirm_password'.tr,
                Icon(Icons.key_rounded, size: 30),
                () => setState(() {
                  redEyecon = !redEyecon;
                }),
                (values) {
                  if (values.isEmpty) {
                    return 'enter_password_pls'.tr;
                  } else if (values != confirmPass) {
                    return "password_no_match".tr;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              button(),
            ],
          ),
        ),
      )),
    );
  }

  Widget textpass(controller, redeye, title, icon, press, value) {
    return TextFormField(
        controller: controller,
        obscureText: redeye,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          // labelText: title,
          hintText: title,
          hintStyle: TextStyle(fontSize: 17),
          errorStyle: TextStyle(fontSize: 15),
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          suffixIcon: IconButton(
            onPressed: press,
            icon: redeye
                ? Icon(
                    Icons.visibility_off,
                    // color: MyConstant.dark,
                  )
                : Icon(
                    Icons.visibility,
                    // color: MyConstant.dark,
                  ),
          ),
        ),
        validator: value);
  }

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: styleButtons(EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              10.0, Colors.white, BorderRadius.circular(10)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("cancel".tr,
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              Map<String, dynamic> valuse = Map();
              valuse['user_name'] = username;
              valuse['old_password'] = _oldpass.text;
              valuse['new_password'] = _conpass.text;
              _changePassword(valuse);
            }
          },
          style: styleButtons(EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              10.0, Theme.of(context).primaryColor, BorderRadius.circular(10)),
          child: Text(
            "save".tr,
            style: TextStyle(
                fontSize: 16,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }
}
