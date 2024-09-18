// ignore_for_file: prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements, avoid_print, use_build_context_synchronously, unused_local_variable, unused_import, prefer_const_constructors, unrelated_type_equality_checks, deprecated_member_use
import 'package:doormster/components/button/button_animation.dart';
import 'package:doormster/components/button/button_language.dart';
import 'package:doormster/components/button/button_theme.dart';
import 'package:doormster/components/checkBox/checkbox_listtile.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_password.dart';
import 'package:doormster/controller/back_double.dart';
import 'package:doormster/controller/login_controller.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login_Page extends StatefulWidget {
  Login_Page({Key? key}) : super(key: key);

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  DateTime pressTime = DateTime.now();
  @override
  void initState() {
    loginController.loadUsernamePassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => onBackDoubleClicked(context, pressTime),
        child: Obx(
          () => Scaffold(
            body: SafeArea(
                child: Form(
              key: loginController.formkey,
              child: SingleChildScrollView(
                  child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      child: Column(
                        children: [
                          themeController.imageTheme(scale: 3.5),
                          SizedBox(
                            height: 10,
                          ),
                          Text_Form(
                            controller: loginController.username,
                            title: 'username'.tr,
                            icon: Icons.account_circle_rounded,
                            error: 'enter_username_pls'.tr,
                            TypeInput: TextInputType.name,
                          ),
                          TextForm_Password(
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
                            textColor: Get.theme.dividerColor,
                            borderColor: Get.theme.dividerColor,
                            checkColor: Get.theme.cardTheme.color!,
                            activeColor: Get.theme.primaryColorDark,
                            value: loginController.remember.value,
                            onChanged: loginController.rememberme,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Button_Animation(
                            title: 'login'.tr,
                            press: () async {
                              await loginController.loginUser();
                            },
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'no_account'.tr,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Divider(
                              thickness: 1,
                            ),
                          ),
                          RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: Get.textTheme.headlineMedium,
                                text: 'login_for'.tr,
                                children: [
                                  TextSpan(
                                      text: 'employee'.tr,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.off(
                                            Login_Staff(),
                                          );
                                        })
                                ],
                              ))
                        ],
                      )),
                  Positioned(
                    top: 20,
                    right: 10,
                    child: button_language(
                        Theme.of(context).primaryColor, Colors.white),
                  ),
                ],
              )),
            )),
          ),
        ));
  }
}
