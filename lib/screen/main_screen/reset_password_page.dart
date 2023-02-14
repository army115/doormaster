// ignore_for_file: prefer_const_constructors

import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

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

  bool redEyeold = true;
  bool redEyenew = true;
  bool redEyecon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('เปลี่ยนรหัสผ่าน'),
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
                'รหัสผ่านปัจจุบัน',
                Icon(
                  Icons.lock_open_rounded,
                  size: 30,
                ),
                () => setState(() {
                  redEyeold = !redEyeold;
                }),
                (values) {
                  if (values!.isEmpty) {
                    return 'กรอกรหัสผ่านปัจจุบัน';
                    // } else if (values != widget.userpass) {
                    //   return "รหัสผ่านปัจจุบันไม่ถูกต้อง";
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
                'รหัสผ่านใหม่',
                Icon(Icons.key_rounded, size: 30),
                () => setState(() {
                  redEyenew = !redEyenew;
                }),
                (values) {
                  confirmPass = values;
                  if (values.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  } else if (values == widget.userpass) {
                    return "ซ้ำกับรหัสผ่านปัจจุบัน กรุณากรอกรหัสผ่านใหม่";
                    // } else if (values.length < 8) {
                    //   return "รหัสผ่านอย่างน้อย 8 ตัว";
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
                'ยืนยันรหัสผ่าน',
                Icon(Icons.key_rounded, size: 30),
                () => setState(() {
                  redEyecon = !redEyecon;
                }),
                (values) {
                  if (values.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  } else if (values != confirmPass) {
                    return "รหัสผ่านไม่ตรงกัน";
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
                    Icons.visibility,
                    // color: MyConstant.dark,
                  )
                : Icon(
                    Icons.visibility_off,
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
        RaisedButton(
          elevation: 5,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("ยกเลิก",
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
        ),
        RaisedButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              Map<String, dynamic> valuse = Map();
              valuse['user_password'] = _conpass.text;
              homeKey.currentState?.popAndPushNamed('/');
              Navigator.pop(context);
            }
          },
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 45, vertical: 8),
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            "บันทึก",
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
