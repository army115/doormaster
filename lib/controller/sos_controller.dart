// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/models/complaint_model/get_sos.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final SOSController sosController = Get.put(SOSController());

class SOSController extends GetxController {
  RxList<Data> listSOS_All = <Data>[].obs;

  Future get_SOS(
      {required start_date, required end_date, required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_sever,
      path: "sel_sos_req_Table_mobile",
      loadingTime: loadingTime,
      values: {"start_date": start_date, "end_date": end_date},
      showError: () {
        error_Connected(() {
          Get.until((route) => route.isFirst);
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Get.until((route) => route.isFirst);
        });
      },
    );
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listSOS_All.assignAll(get_sos.fromJson(values).data!);
      });
    } else {
      listSOS_All.value = [];
    }
  }

  Future add_SOS(value) async {
    await connectApi.callApi_addformData(
        ip: IP_Address.guard_IP_sever,
        path: "add_sos_req",
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
        ip: IP_Address.guard_IP_sever,
        path: "edit_req_sos",
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
        ip: IP_Address.guard_IP_sever,
        path: "approve_sos_req",
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
