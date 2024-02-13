// ignore_for_file: invalid_use_of_protected_member

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/profile_model.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ProfileController Profilecontroller = Get.put(ProfileController());

class ProfileController extends GetxController {
  Rx<bool> loading = false.obs;
  RxList profileInfo = <Data>[].obs;
  String? imageProfile;

  @override
  void onInit() async {
    super.onInit();
    getInfo(500);
  }

  @override
  void onClose() {
    profileInfo.value.clear();
    super.onClose();
  }

  Future getInfo(time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    print('userId: ${userId}');

    try {
      loading.value = true;

      await Future.delayed(Duration(milliseconds: time));

      var url = '${Connect_api().domain}/get/profile/$userId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        profileInfo.value.assignAll(GetProfile.fromJson(response.data).data!);
        imageProfile = profileInfo.single.image;
      }
    } on DioError catch (e) {
      print(e.response);
      dialogOnebutton_Subtitle('found_error'.tr, 'connect_fail'.tr,
          Icons.warning_amber_rounded, Colors.orange, 'ok'.tr, () {
        Get.back();
        getInfo(500);
      }, false, false);
    } finally {
      loading.value = false;
    }
  }

  Future editProfile(Map<String, dynamic> values) async {
    try {
      loading.value = true;

      await Future.delayed(Duration(milliseconds: 500));

      var url = '${Connect_api().domain}/edit/profile';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);
      var _response = response.data['status'];
      print("status code : ${_response}");

      if (_response == 200) {
        print('edit Success');
        _sharedInfo(values['first_name'], values['sur_name'], values['image']);
        Get.back();
        snackbar(Get.theme.primaryColor, 'edit_success'.tr,
            Icons.check_circle_outline_rounded);
        getInfo(0);
      } else {
        dialogOnebutton_Subtitle('found_error'.tr, 'connect_fail'.tr,
            Icons.warning_amber_rounded, Colors.orange, 'ok'.tr, () {
          Get.back();
        }, false, false);
        print('checkIn not Success!!');
        // print(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
      error_connected(() async {
        Get.back();
        getInfo(500);
      });
    } finally {
      loading.value = false;
    }
  }

  Future _sharedInfo(fname, lname, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('fname', fname);
    await prefs.setString('lname', lname);
    if (image != null) {
      await prefs.setString('image', image!);
    }
  }
}
