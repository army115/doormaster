// ignore_for_file: prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements, avoid_print, use_build_context_synchronously, unused_local_variable, prefer_const_constructors
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button_animation.dart';
import 'package:doormster/components/button/button_language.dart';
import 'package:doormster/components/button/button_theme.dart';
import 'package:doormster/components/checkBox/checkbox_listtile.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_password.dart';
import 'package:doormster/controller/back_double.dart';
import 'package:doormster/controller/login_controller.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  DateTime pressTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => onBackButtonDoubleClicked(context, pressTime),
      child: Obx(
        () => Scaffold(
            // backgroundColor: Get.theme.primaryColor,
            body: SingleChildScrollView(
          child: Form(
            key: loginController.key,
            child: Stack(
              children: [
                PhysicalModel(
                  // borderRadius: BorderRadius.circular(10),
                  elevation: 10,
                  color: Get.theme.primaryColor,
                  child: Container(
                    width: Get.mediaQuery.size.width,
                    height: Get.mediaQuery.size.height * 0.55,
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
                        'login_for_employee'.tr,
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
                                controller: loginController.username_staff,
                                title: 'username'.tr,
                                icon: Icons.account_circle_rounded,
                                error: 'enter_username_pls'.tr,
                                TypeInput: TextInputType.name,
                              ),
                              TextForm_Password(
                                controller: loginController.password_staff,
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
                              Checkbox_Listtile(
                                title: 'remember'.tr,
                                value: loginController.remember.value,
                                onChanged: loginController.rememberme,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Button_Animation(
                                title: 'login'.tr,
                                press: () async {
                                  await loginController.loginStaff();
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
                                    text: 'login_for'.tr,
                                    children: [
                                      TextSpan(
                                          text: 'user'.tr,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Get.theme.primaryColor,
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
                ),
                Positioned(
                  top: 40,
                  right: 10,
                  child: button_language(Colors.white, Get.theme.primaryColor),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget btnSubmit(String title, VoidCallback press) {
    return Container(
      width: Get.mediaQuery.size.width * 0.5,
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
