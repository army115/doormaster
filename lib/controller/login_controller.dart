// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/login_model.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

final LoginController loginController = Get.put(LoginController());

class LoginController extends GetxController {
  final formkey = GlobalKey<FormState>();
  final key = GlobalKey<FormState>();
  Rx<bool> loading = false.obs;
  Rx<bool> remember = false.obs;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username_staff = TextEditingController();
  TextEditingController password_staff = TextEditingController();

  @override
  void onInit() async {
    loadUsernamePassword();
    super.onInit();
  }

  void rememberme(bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("remember", value!);
    remember.value = value;
    print('remember : $remember');
  }

  void loadUsernamePassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var user = prefs.getString("username");
      var pass = prefs.getString("password");
      var remeberMe = prefs.getBool("remember") ?? false;
      log(remeberMe.toString());
      if (remeberMe) {
        remember.value = true;
        username.text = user!;
        password.text = pass!;
      } else {
        username.clear();
        password.clear();
        prefs.remove('username');
        prefs.remove('password');
      }
      print('remember : $remember');
    } catch (e) {
      print(e);
    }
  }

  Future loginUser() async {
    if (formkey.currentState!.validate()) {
      try {
        await Future.delayed(const Duration(milliseconds: 600));

        loading.value = true;

        // เชื่อมต่อ api
        String url = '${Connect_api().domain}/login';
        var body = {
          "user_name": username.text,
          "user_password": password.text,
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
          if (jsonRes.status == 200) {
            var token = jsonRes.accessToken;
            List<User> data = jsonRes.user!; //ตัวแปร List จาก model
            if (data.single.block == 0 || data.single.block == null) {
              //ส่งค่าตัวแปร
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token!);
              await prefs.setString('username', data.single.userName!);
              await prefs.setString('password', password.text);
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
              Get.off(() => BottomBar());
              bottomController.ontapItem(0);
              snackbar(Get.theme.primaryColor, 'login_success'.tr,
                  Icons.check_circle_outline_rounded);
              print('login success');
            } else {
              print('account block');
              dialogOnebutton_Subtitle(
                  'account_block'.tr,
                  'unblock_account'.tr,
                  Icons.warning_amber_rounded,
                  Colors.orange,
                  'ok'.tr, () async {
                Get.back();
              }, false, false);
            }
          } else {
            print(jsonRes.data);
            print('ชื่อผู้ใช้ หรือ รหัสผ่าน ไม่ถูกต้อง');
            snackbar(
                Colors.red, 'wrong_username'.tr, Icons.highlight_off_rounded);
          }
        } else {
          print(response.statusCode);
          print('Connection Fail');
          snackbar(Colors.red, 'login_failed'.tr, Icons.highlight_off_rounded);
        }
      } on DioError catch (e) {
        print(e);
        error_connected(() {
          Get.back();
        });
      } finally {
        loading.value = false;
      }
    } else {
      snackbar(
          Colors.orange, 'enter_info_error'.tr, Icons.warning_amber_rounded);
    }
  }

  Future loginStaff() async {
    if (key.currentState!.validate()) {
      try {
        await Future.delayed(const Duration(milliseconds: 600));
        loading.value = true;
        // เชื่อมต่อ api
        String url = '${Connect_api().domain}/loginsecurity';
        var body = {
          "user_name": username_staff.text,
          "user_password": password_staff.text,
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

            if (data.single.block == 0) {
              // ส่งค่าตัวแปร
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('token', token!);
              await prefs.setString('sId', data.single.sId!);
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

              //บันทึก deviece token ลง database
              Notify_Token()
                  .create_notifyToken(data.single.companyId, data.single.sId);

              Get.off(BottomBar());
              bottomController.ontapItem(0);
              snackbar(Get.theme.primaryColor, 'login_success'.tr,
                  Icons.check_circle_outline_rounded);
              print('login success');
            } else {
              print(jsonRes.data);
              print('account block');
              dialogOnebutton_Subtitle(
                  'account_block'.tr,
                  'unblock_account'.tr,
                  Icons.warning_amber_rounded,
                  Colors.orange,
                  'ok'.tr, () async {
                Get.back();
              }, false, false);
            }
          } else {
            print(jsonRes.data);
            print('username หรือ password ไม่ถูกต้อง');
            snackbar(
                Colors.red, 'wrong_username'.tr, Icons.highlight_off_rounded);
          }
        } else {
          print(response.statusCode);
          print('Connection Fail');
          snackbar(Colors.red, 'login_failed'.tr, Icons.highlight_off_rounded);
        }
      } on DioError catch (e) {
        print(e);
        error_connected(() {
          Get.back();
        });
      } finally {
        loading.value = false;
      }
    } else {
      snackbar(
          Colors.orange, 'enter_info_error'.tr, Icons.warning_amber_rounded);
    }
  }
}
