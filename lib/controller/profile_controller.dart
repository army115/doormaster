// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/models/main_models/get_profile.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ProfileController profileController = Get.put(ProfileController());

class ProfileController extends GetxController {
  Rx<getProfile> profileInfo = getProfile().obs;

  Future get_Profile({required loadingTime}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final values = await connectApi.callApi_getData(
        ip: IP_Address.emp_IP_sever,
        path: "Get_Employee_Info",
        loadingTime: loadingTime,
        showError: () {
          error_Connected(() {
            Get.back();
            get_Profile(loadingTime: 100);
          }, click: true, back_btn: true);
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
            get_Profile(loadingTime: 100);
          }, click: true, back_btn: true);
        });
    if (values != null && values['data'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        profileInfo.value = getProfile.fromJson(values);
        await prefs.setString('userId', profileInfo.value.data!.employeeNo!);
        await prefs.setString('fname', profileInfo.value.data!.firstName!);
        await prefs.setString('lname', profileInfo.value.data!.lastName!);
        if (profileInfo.value.data!.profileImg != null) {
          await prefs.setString('image', profileInfo.value.data!.profileImg!);
        }
      });
    } else {
      profileInfo.value = getProfile();
    }
  }

  Future edit_Complaint(value) async {
    await connectApi.callApi_addformData(
      ip: IP_Address.emp_IP_sever,
      path: 'Update_Employee',
      loadingTime: 100,
      values: value,
      showSuccess: () {
        dialogOnebutton(
            title: 'save_success'.tr,
            icon: Icons.check_circle_outline_rounded,
            colorIcon: Colors.green,
            textButton: 'ok'.tr,
            press: () {
              get_Profile(loadingTime: 0);
              Get.until((route) => route.isFirst);
            },
            click: false,
            willpop: false);
      },
      showError: () {
        error_Connected(() {
          Get.back();
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Get.back();
        });
      },
    );
  }
}
