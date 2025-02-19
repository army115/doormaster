// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/utils/date_time_utils.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/models/complaint_model/get_sos.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SOSController extends GetxController {
  RxList<Data> listSOS = <Data>[].obs;
  RxList<Data> filterSOS = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_SOS(start_date: '', end_date: '', loadingTime: 100);
    });
  }

  void searchData(String text) {
    listSOS.value = filterSOS.where((item) {
      var name = item.docName ?? '';
      var createDate = DateTimeUtils.format(item.createDate!, 'D');
      var status = item.status ?? '';
      return name.contains(text) ||
          createDate.contains(text) ||
          status.contains(text);
    }).toList();
  }

  Future get_SOS(
      {required start_date, required end_date, required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_server,
      path: SOSPath.SOS,
      loadingTime: loadingTime,
      values: {"start_date": start_date, "end_date": end_date},
      showError: () {
        error_Connected(() {
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.qrsmart));
          Get.back();
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.qrsmart));
          Get.back();
        });
      },
    );
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listSOS.assignAll(getSOS.fromJson(values).data!);
        filterSOS.assignAll(listSOS);
      });
    } else {
      listSOS.clear();
      filterSOS.clear();
    }
  }

  Future add_SOS(value) async {
    await connectApi.callApi_addformData(
        ip: IP_Address.guard_IP_server,
        path: SOSPath.AddSOS,
        loadingTime: 100,
        values: value,
        showSuccess: () {
          dialogOnebutton(
              title: 'save_success'.tr,
              icon: Icons.check_circle_outline_rounded,
              colorIcon: Colors.green,
              textButton: 'ok'.tr,
              press: () {
                Get.until((route) => route.isFirst);
                get_SOS(start_date: '', end_date: '', loadingTime: 0);
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
        });
  }

  Future edit_SOS(value) async {
    await connectApi.callApi_addformData(
        ip: IP_Address.guard_IP_server,
        path: SOSPath.EditSOS,
        loadingTime: 100,
        values: value,
        showSuccess: () {
          dialogOnebutton(
              title: 'save_success'.tr,
              icon: Icons.check_circle_outline_rounded,
              colorIcon: Colors.green,
              textButton: 'ok'.tr,
              press: () {
                get_SOS(start_date: '', end_date: '', loadingTime: 0);
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
        });
  }

  Future updateStatus_SOS({required doc_id}) async {
    await connectApi.callApi_addData(
        ip: IP_Address.guard_IP_server,
        path: SOSPath.CancelSOS,
        loadingTime: 100,
        values: {'doc_id': doc_id, 'status': 4},
        showSuccess: () {
          dialogOnebutton(
              title: 'cancel_success'.tr,
              icon: Icons.check_circle_outline_rounded,
              colorIcon: Colors.green,
              textButton: 'ok'.tr,
              press: () {
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
        });
  }
}
