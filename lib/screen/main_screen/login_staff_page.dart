// ignore_for_file: prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements, avoid_print, use_build_context_synchronously, unused_local_variable, prefer_const_constructors

import 'package:doormster/widgets/actions/form_error_snackbar.dart';
import 'package:doormster/widgets/button/button_animation.dart';
import 'package:doormster/widgets/button/button_language.dart';
import 'package:doormster/widgets/checkBox/checkbox_listtile.dart';
import 'package:doormster/widgets/snackbar/back_double.dart';
import 'package:doormster/widgets/text_form/text_form.dart';
import 'package:doormster/widgets/text_form/text_form_password.dart';
import 'package:doormster/controller/main_controller/login_controller.dart';
import 'package:doormster/utils/scroll_field.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert' as convert;

class Login_Staff extends StatefulWidget {
  Login_Staff({Key? key}) : super(key: key);

  @override
  State<Login_Staff> createState() => _Login_StaffState();
}

class _Login_StaffState extends State<Login_Staff> {
  final LoginController loginController = Get.find<LoginController>();

  final formkey = GlobalKey<FormState>();

  final List<GlobalKey<FormFieldState>> _fieldKeys =
      List.generate(2, (index) => GlobalKey<FormFieldState>());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          // backgroundColor: Theme.of(context).primaryColor,
          body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Stack(
            children: [
              PhysicalModel(
                // borderRadius: BorderRadius.circular(10),
                elevation: 10,
                color: Theme.of(context).primaryColor,
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
                      'assets/images/HIP_Smart_Community_Logo_White.png',
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
                              fieldKey: _fieldKeys[0],
                              controller: loginController.username,
                              title: 'username'.tr,
                              icon: Icons.account_circle_rounded,
                              error: 'enter_username_pls'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            TextForm_Password(
                              fieldKey: _fieldKeys[1],
                              controller: loginController.password,
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
                              textColor: Colors.black,
                              borderColor: Colors.black,
                              checkColor: Colors.white,
                              activeColor: Get.theme.primaryColor,
                              value: loginController.remember.value,
                              onChanged: loginController.rememberme,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Button_Animation(
                              title: 'login'.tr,
                              press: () async {
                                if (formkey.currentState!.validate()) {
                                } else {
                                  for (var key in _fieldKeys) {
                                    if (!key.currentState!.validate()) {
                                      scrollToField(key);
                                      break;
                                    }
                                    form_error_snackbar();
                                  }
                                }
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
                                          decoration: TextDecoration.underline,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Get.off(() => Login_Page());
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
                top: 60,
                right: 10,
                child: button_language(
                    Colors.white, Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
