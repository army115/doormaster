// ignore_for_file: non_constant_identifier_names

import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final PasswordController passwordController = PasswordController();

class PasswordController {
  Future change_Passord({required value}) async {
    await connectApi.callApi_Password(
        ip: IP_Address.emp_IP_server,
        path: MainPath.ChangePassword,
        values: value,
        showSuccess: () {
          dialogOnebutton(
              title: 'password_success'.tr,
              icon: Icons.check_circle_outline_sharp,
              colorIcon: Colors.green,
              textButton: 'ok'.tr,
              press: () {
                Get.until(
                  (route) => route.isFirst,
                );
              },
              click: false,
              willpop: false);
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
          });
        },
        showError: () {
          dialogOnebutton_Subtitle(
              title: 'occur_error'.tr,
              subtitle: 'wrong_password'.tr,
              icon: Icons.highlight_off_rounded,
              colorIcon: Colors.red,
              textButton: 'ok'.tr,
              press: () {
                Get.back();
              },
              click: false,
              backBtn: false,
              willpop: false);
        });
  }
}
