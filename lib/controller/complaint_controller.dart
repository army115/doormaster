// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/models/complaint_model/complaint_type.dart';
import 'package:doormster/models/complaint_model/get_complaint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final ComplaintController complaintController = Get.put(ComplaintController());

class ComplaintController extends GetxController {
  RxList<DataType> type_list = <DataType>[].obs;
  RxList<Data> listComplaint_All = <Data>[].obs;

  Future get_ComplaintAll(
      {required start_date, required end_date, required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_sever,
      path: "Get_complaint_req_Table_mobile",
      loadingTime: loadingTime,
      values: {'start_date': '$start_date', 'end_date': '$end_date'},
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
        listComplaint_All.assignAll(get_complaint.fromJson(values).data!);
      });
    } else {
      listComplaint_All.value = [];
    }
  }

  Future get_TypeComplaint() async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.guard_IP_sever,
        path: "sel_complaint_type_both",
        loadingTime: 100,
        showError: () {
          error_Connected(() {
            Get.until((route) => route.isFirst);
          });
        },
        showTimeout: (() {
          error_Timeout(() {
            Get.until((route) => route.isFirst);
          });
        }));
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        type_list.assignAll(complaint_type.fromJson(values).data!);
      });
    } else {
      type_list.value = [];
    }
  }

  Future add_Complaint(value) async {
    await connectApi.callApi_addformData(
      ip: IP_Address.guard_IP_sever,
      path: "add_complaint_req",
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
      },
    );
  }

  Future edit_Complaint(value) async {
    await connectApi.callApi_addformData(
      ip: IP_Address.guard_IP_sever,
      path: "edit_req_complaint",
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
      },
    );
  }

  Future updateStatus_Complaint(
      {required doc_id,
      required status,
      required succress,
      required fail}) async {
    await connectApi.callApi_addData(
        ip: IP_Address.guard_IP_sever,
        path: "approve_complaint_req",
        loadingTime: 100,
        values: {'doc_id': doc_id, 'status': status},
        showSuccess: () {
          dialogOnebutton(
              title: succress.tr,
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
