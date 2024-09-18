// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ConnectApi connectApi = Get.put(ConnectApi());

class ConnectApi extends GetxController {
  Rx<bool> loading = false.obs;
  Future callApi_getData({
    required String ip,
    required String path,
    required int loadingTime,
    required Function showError,
    required Function showTimeout,
    Map<String, dynamic>? values,
  }) async {
    try {
      if (loadingTime != 0) {
        loading.value = true;
      } else {
        loading.value = false;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? guardToken = prefs.getString('token');

      await Future.delayed(Duration(milliseconds: loadingTime));

      var url = '$ip$path';
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $guardToken'
                },
              ),
              data: values)
          .timeout(
            const Duration(seconds: 5),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success');
        return response.data;
      }
    } on TimeoutException catch (e) {
      print('Timeout : $e');
      showTimeout();
    } on dio.DioError catch (error) {
      print(" error: ${error.message}");
      showError();
      return null;
    } finally {
      loading.value = false;
    }
  }

  Future callApi_addData({
    required String ip,
    required String path,
    required int loadingTime,
    required Function showSuccess,
    required Function showTimeout,
    required Function showError,
    required Map<String, dynamic> values,
  }) async {
    try {
      loading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? guardToken = prefs.getString('token');
      await Future.delayed(Duration(milliseconds: loadingTime));
      var url = '$ip$path';
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $guardToken'
              }),
              data: values)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success');
        showSuccess();
        return response.data;
      }
    } on TimeoutException catch (e) {
      print('Timeout : $e');
      showTimeout();
    } on dio.DioError catch (error) {
      print(" error: ${error.message}");
      showError();
    } finally {
      loading.value = false;
    }
  }

  Future callApi_addformData({
    required String ip,
    required String path,
    required int loadingTime,
    required Function showSuccess,
    required Function showTimeout,
    required Function showError,
    required Map<String, dynamic> values,
  }) async {
    try {
      loading.value = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? guardToken = prefs.getString('token');
      await Future.delayed(Duration(milliseconds: loadingTime));
      var url = '$ip$path';
      var formData = dio.FormData.fromMap(values);
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $guardToken'
              }),
              data: formData)
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Success');
        showSuccess();
        return response.data;
      }
    } on TimeoutException catch (e) {
      print('Timeout : $e');
      showTimeout();
    } on dio.DioError catch (error) {
      print(" error: ${error.message}");
      showError();
    } finally {
      loading.value = false;
    }
  }

  Future callApi_Login({
    required String ip,
    required String path,
    required Function showError,
    required Function showTimeout,
    Map<String, dynamic>? values,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      loading.value = true;
      var url = '$ip$path';
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
              data: values)
          .timeout(
            const Duration(seconds: 5),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        snackbar(Get.theme.primaryColor, 'login_success'.tr,
            Icons.check_circle_outline_rounded);
        print('login success');
        return response.data;
      }
    } on TimeoutException catch (e) {
      print('Timeout : $e');
      showTimeout();
    } on dio.DioError catch (error) {
      if (error.response?.statusCode == 401) {
        dialogOnebutton_Subtitle(
            title: 'occur_error'.tr,
            subtitle: '${error.response!.data['message']}',
            icon: Icons.highlight_off_rounded,
            colorIcon: Colors.red,
            textButton: 'ok'.tr,
            press: () {
              Get.back();
            },
            click: false,
            backBtn: false,
            willpop: false);
      } else {
        error_Connected(() {
          Get.back();
        });
        print(error.message);
      }
    } finally {
      loading.value = false;
    }
  }
}
