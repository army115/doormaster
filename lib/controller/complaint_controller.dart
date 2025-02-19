// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/utils/date_time_utils.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/models/complaint_model/complaint_type.dart';
import 'package:doormster/models/complaint_model/get_complaint.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController {
  RxList<DataType> listType = <DataType>[].obs;
  RxList<Data> listComplaint = <Data>[].obs;
  RxList<Data> filterComplaint = <Data>[].obs;
  RxString language = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_ComplaintAll(start_date: '', end_date: '', loadingTime: 100)
          .then(
        (value) async {
          if (value != null) {
            await get_TypeComplaint();
          }
        },
      );
      final getlanguage = await SecureStorageUtils.readString('language');
      language.value = getlanguage ?? '';
    });
  }

  void searchData(String text) {
    listComplaint.value = filterComplaint.where((item) {
      var name = item.docName ?? '';
      var date = DateTimeUtils.format(item.createDate!, 'D');
      var status = item.status ?? '';
      return name.contains(text) ||
          date.contains(text) ||
          status.contains(text);
    }).toList();
  }

  Future get_ComplaintAll(
      {required start_date, required end_date, required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_server,
      path: ComplaintPath.Complaint,
      loadingTime: loadingTime,
      values: {'start_date': '$start_date', 'end_date': '$end_date'},
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
        listComplaint.assignAll(getComplaint.fromJson(values).data!);
        filterComplaint.assignAll(listComplaint);
      });
      return values;
    } else {
      listComplaint.clear();
      filterComplaint.clear();
      return null;
    }
  }

  Future get_TypeComplaint() async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.guard_IP_server,
        path: ComplaintPath.TypeComplaint,
        loadingTime: 0,
        showError: () {
          error_Connected(() {
            Keys.home?.currentState
                ?.popUntil(ModalRoute.withName(Routes.qrsmart));
            Get.back();
          });
        },
        showTimeout: (() {
          error_Timeout(() {
            Keys.home?.currentState
                ?.popUntil(ModalRoute.withName(Routes.qrsmart));
            Get.back();
          });
        }));
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listType.assignAll(complaint_type.fromJson(values).data!);
      });
    } else {
      listType.clear();
    }
  }

  Future add_Complaint(value) async {
    await connectApi.callApi_addformData(
      ip: IP_Address.guard_IP_server,
      path: ComplaintPath.AddComplaint,
      loadingTime: 1001,
      values: value,
      showSuccess: () {
        dialogOnebutton(
            title: 'save_success'.tr,
            icon: Icons.check_circle_outline_rounded,
            colorIcon: Colors.green,
            textButton: 'ok'.tr,
            press: () {
              Get.until((route) => route.isFirst);
              get_ComplaintAll(start_date: '', end_date: '', loadingTime: 0);
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
      ip: IP_Address.guard_IP_server,
      path: ComplaintPath.EditComplaint,
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
              get_ComplaintAll(start_date: '', end_date: '', loadingTime: 0);
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
        ip: IP_Address.guard_IP_server,
        path: ComplaintPath.CancelComplaint,
        loadingTime: 100,
        values: {'doc_id': doc_id, 'status': status},
        showSuccess: () {
          dialogOnebutton(
              title: succress,
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
