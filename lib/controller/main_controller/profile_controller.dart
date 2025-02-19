// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'package:doormster/screen/test_chat/auth_service.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/models/main_models/get_profile.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ProfileController profileController = ProfileController();

class ProfileController extends GetxController {
  Rx<getProfile> profileInfo = getProfile().obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      get_Profile(loadingTime: 100);
    });
  }

  Future get_Profile({required loadingTime, page}) async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.emp_IP_server,
        path: MainPath.UserInfo,
        loadingTime: loadingTime,
        showError: () {
          if (page != 'home') {
            error_Connected(() {
              Get.back();
              get_Profile(loadingTime: 100);
            }, click: true, back_btn: true);
          }
        },
        showTimeout: () {
          if (page != 'home') {
            error_Timeout(() {
              Get.back();
              get_Profile(loadingTime: 100);
            }, click: true, back_btn: true);
          }
        });
    if (values != null && values['data'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        profileInfo.value = getProfile.fromJson(values);
        await SecureStorageUtils.writeString(
            'userId', profileInfo.value.data!.employeeNo!);
        await SecureStorageUtils.writeString(
            'fname', profileInfo.value.data!.firstName!);
        await SecureStorageUtils.writeString(
            'lname', profileInfo.value.data!.lastName!);
        if (profileInfo.value.data!.profileImg != null) {
          await SecureStorageUtils.writeString(
              'image', profileInfo.value.data!.profileImg!);
        }
        await checkLoginFirebase();
      });
      return values['data']['employee_no'];
    } else {
      profileInfo.value = getProfile();
      return null;
    }
  }

  Future edit_Profile(value) async {
    await connectApi.callApi_addformData(
      ip: IP_Address.emp_IP_server,
      path: MainPath.UpdateInfo,
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

  Future checkLoginFirebase() async {
    String? password = await SecureStorageUtils.readString('password');

    if (AuthService().auth.currentUser == null) {
      AuthService().createUserFirebase(
          email: profileInfo.value.data!.email!,
          password: password!,
          displayName:
              '${profileInfo.value.data!.firstName!} ${profileInfo.value.data!.lastName!}',
          photoPath: profileInfo.value.data!.profileImg!,
          phoneNumber: profileInfo.value.data!.phone!);
      SecureStorageUtils.writeBool('firstTime', false);
    } else {
      AuthService().updateInfoUser(
          email: profileInfo.value.data!.email!,
          displayName:
              '${profileInfo.value.data!.firstName!} ${profileInfo.value.data!.lastName!}',
          photoPath: profileInfo.value.data!.profileImg!,
          phoneNumber: profileInfo.value.data!.phone!);
    }
  }
}
