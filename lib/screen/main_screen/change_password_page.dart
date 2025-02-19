// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/text_form/text_form_password.dart';
import 'package:doormster/controller/main_controller/change_password_controller.dart';
import 'package:doormster/style/styleButton/ButtonStyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Password_Page extends StatefulWidget {
  Password_Page({
    Key? key,
  }) : super(key: key);

  @override
  State<Password_Page> createState() => _Password_PageState();
}

class _Password_PageState extends State<Password_Page> {
  final _formkey = GlobalKey<FormState>();
  final _oldpass = TextEditingController();
  final _newpass = TextEditingController();
  final _conpass = TextEditingController();
  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(3, (index) => GlobalKey<FormFieldState>());
  var confirmPass;
  bool loading = false;

  bool redEyeold = true;
  bool redEyenew = true;
  bool redEyecon = true;
  bool focusColor = false;
  bool focusColor2 = false;
  bool focusColor3 = false;

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
              TextForm_Password(
                  controller: _oldpass,
                  title: 'current_password'.tr,
                  iconLaft: Icons.lock_open_rounded,
                  error: (values) {
                    if (values!.isEmpty) {
                      return 'enter_password_current'.tr;
                    } else {
                      return null;
                    }
                  },
                  fieldKey: _fieldKeys[0]),
              // รหัสผ่านใหม่*****************************************************************************
              TextForm_Password(
                  controller: _newpass,
                  title: 'new_password'.tr,
                  iconLaft: Icons.key_rounded,
                  error: (values) {
                    confirmPass = values;
                    if (values.isEmpty) {
                      return 'enter_password_pls'.tr;
                      // } else if (values == widget.userpass) {
                      //   return "same_password".tr;
                      // } else if (values.length < 8) {
                      //   return "password_8char".tr;
                    } else {
                      return null;
                    }
                  },
                  fieldKey: _fieldKeys[1]),

              // ยืนยันรหัสผ่าน*****************************************************************************
              TextForm_Password(
                  controller: _conpass,
                  title: 'confirm_password'.tr,
                  iconLaft: Icons.key_rounded,
                  error: (values) {
                    if (values.isEmpty) {
                      return 'enter_password_pls'.tr;
                    } else if (values != confirmPass) {
                      return "password_no_match".tr;
                    } else {
                      return null;
                    }
                  },
                  fieldKey: _fieldKeys[1]),
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

  Widget button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: styleButtons(EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              10.0, Colors.white, BorderRadius.circular(10)),
          onPressed: () {
            Get.back();
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
              Map<String, dynamic> values = Map();
              values['old_password'] = _oldpass.text;
              values['new_password'] = _conpass.text;
              passwordController.change_Passord(value: values);
            } else {
              form_error_snackbar();
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
