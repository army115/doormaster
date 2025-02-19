// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:dio/dio.dart' as dio;
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ConnectApi connectApi = ConnectApi();

class ConnectApi extends GetxController {
  RxBool loading = false.obs;
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

      String? token = await SecureStorageUtils.readString('token');

      await Future.delayed(Duration(milliseconds: loadingTime));

      var url = '$ip$path';
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token'
                },
              ),
              data: values)
          .timeout(
            const Duration(seconds: 7),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Success');
        return response.data;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout : $e');
      showTimeout();
      return null;
    } on dio.DioError catch (error) {
      debugPrint("error: ${error.message}");
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
      String? token = await SecureStorageUtils.readString('token');
      await Future.delayed(Duration(milliseconds: loadingTime));
      var url = '$ip$path';
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }),
              data: values)
          .timeout(const Duration(seconds: 7));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Success');
        showSuccess();
        return response.data;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout : $e');
      showTimeout();
      return e.message;
    } on dio.DioError catch (error) {
      debugPrint(" error: ${error.message}");
      showError();
      return error.message;
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
      String? token = await SecureStorageUtils.readString('token');
      await Future.delayed(Duration(milliseconds: loadingTime));
      var url = '$ip$path';
      var formData = dio.FormData.fromMap(values);
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token'
              }),
              data: formData)
          .timeout(const Duration(seconds: 7));
      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Success');
        showSuccess();
        return response.data;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout : $e');
      showTimeout();
    } on dio.DioError catch (error) {
      debugPrint(" error: ${error.message}");
      showError();
    } finally {
      loading.value = false;
    }
  }

  Future callApi_Login({
    required String ip,
    required String path,
    required Function showTimeout,
    Map<String, dynamic>? values,
  }) async {
    try {
      loading.value = true;
      await Future.delayed(const Duration(milliseconds: 600));
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
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        snackbar(Colors.green, 'login_success'.tr,
            Icons.check_circle_outline_rounded);
        debugPrint('login success');
        return response.data;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout : $e');
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
        debugPrint(error.message);
      }
    } finally {
      loading.value = false;
    }
  }

  Future callApi_Password({
    required String ip,
    required String path,
    required Function showSuccess,
    required Function showTimeout,
    required Function showError,
    Map<String, dynamic>? values,
  }) async {
    try {
      loading.value = true;

      String? token = await SecureStorageUtils.readString('token');

      await Future.delayed(const Duration(milliseconds: 600));

      var url = '$ip$path';
      var response = await dio.Dio()
          .post(url,
              options: dio.Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer $token'
                },
              ),
              data: values)
          .timeout(
            const Duration(seconds: 10),
          );
      if (response.statusCode == 200) {
        showSuccess();
        return response.data;
      }
    } on TimeoutException catch (e) {
      debugPrint('Timeout : $e');
      showTimeout();
      return null;
    } on dio.DioError catch (error) {
      debugPrint("error: ${error.message}");
      if (error.response!.statusCode == 500) {
        showError();
      } else {
        error_Connected(() {
          Get.back();
        });
      }
      return error.response!.data;
    } finally {
      loading.value = false;
    }
  }
}
