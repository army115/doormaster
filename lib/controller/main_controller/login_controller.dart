// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/bottombar/bottom_controller.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class LoginController extends GetxController {
  RxBool loading = false.obs;
  RxBool remember = false.obs;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void onInit() {
    loadUsernamePassword();
    super.onInit();
  }

  void rememberme(bool? value) async {
    await SecureStorageUtils.writeBool("remember", value!);
    remember.value = value;
    debugPrint('remember : $remember');
  }

  void loadUsernamePassword() async {
    try {
      var user = await SecureStorageUtils.readString('username');
      var pass = await SecureStorageUtils.readString('password');
      var remeberMe = await SecureStorageUtils.readBool("remember") ?? false;
      log('remember : $remeberMe');
      if (remeberMe) {
        remember.value = true;
        username.text = user!;
        password.text = pass!;
      } else {
        username.clear();
        password.clear();
        SecureStorageUtils.delete('username');
        SecureStorageUtils.delete('password');
      }
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  Future loginUser() async {
    final values = await connectApi.callApi_Login(
        ip: IP_Address.emp_IP_server,
        path: MainPath.Login,
        values: {
          "employee_no": username.text,
          "password": password.text,
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
          }, click: true, back_btn: false);
        });
    if (values != null && values['status'] == 200) {
      //บันทึก deviece token ลง database
      // Notify_Token()
      // .create_notifyToken(data.single.companyId, data.single.sId);
      int roleId = values['role_id'];
      String token = values['token'];
      String refreshToken = values['refreshToken'];

      await SecureStorageUtils.writeInt('role_id', roleId);
      await SecureStorageUtils.writeString('token', token);
      await SecureStorageUtils.writeString('refreshToken', refreshToken);
      await SecureStorageUtils.writeString('username', username.text);
      await SecureStorageUtils.writeString('password', password.text);
      Get.offNamed(Routes.bottom);
      bottomController.ontapItem(0);
    }
  }

  Future refreshToken() async {
    final refreshToken = await SecureStorageUtils.readString('refreshToken');
    final values = await connectApi.callApi_getData(
      ip: IP_Address.emp_IP_server,
      path: MainPath.RefreshToken,
      loadingTime: 0,
      values: {'refreshToken': refreshToken},
      showError: () {},
      showTimeout: () {},
    );
    if (values != null) {
      String token = values['token'];
      await SecureStorageUtils.writeString('token', token);
    }
  }
}
