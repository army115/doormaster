// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/models/secarity_models/get_log_all.dart';
import 'package:doormster/models/secarity_models/get_logs_img.dart';
import 'package:doormster/models/secarity_models/get_logs_round.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final LogsController logsController = Get.put(LogsController());

class LogsController extends GetxController {
  RxList<logAll> listLog_Today = <logAll>[].obs;
  RxList<logAll> listLog_All = <logAll>[].obs;
  RxList<logRound> listLog_Round = <logRound>[].obs;

  Future get_logToday({required loadingTime}) async {
    String date = DateFormat('y-MM-dd').format(DateTime.now());
    var response = await connectApi.callApi_getData(
      values: {
        'start_date': date,
        'end_date': date,
        "inspect_id": "",
        "branch_id": ""
      },
      ip: IP_Address.guard_IP_sever,
      path: "Get_guard_logs_mobile",
      loadingTime: loadingTime,
      showError: () {
        error_Connected(() {
          Keys.home?.currentState?.popUntil(ModalRoute.withName('/security'));
          Get.back();
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Keys.home?.currentState?.popUntil(ModalRoute.withName('/security'));
          Get.back();
        });
      },
    );
    if (response != null) {
      listLog_Today.assignAll(getLogs_All.fromJson(response).data!);
      return response;
    } else {
      listLog_Today.value = [];
      return null;
    }
  }

  Future get_logAll(
      {required start_date, required end_date, required loadingTime}) async {
    await connectApi.callApi_getData(
      values: {
        'start_date': start_date,
        'end_date': end_date,
        "inspect_id": "",
        "branch_id": ""
      },
      ip: IP_Address.guard_IP_sever,
      path: "Get_guard_logs_mobile",
      loadingTime: loadingTime,
      showError: () {
        error_Connected(() {
          Keys.home?.currentState?.popUntil(ModalRoute.withName('/security'));
          Get.back();
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Keys.home?.currentState?.popUntil(ModalRoute.withName('/security'));
          Get.back();
        });
      },
    ).then((value) {
      if (value != null) {
        listLog_All.assignAll(getLogs_All.fromJson(value).data!);
      } else {
        listLog_All.value = [];
      }
    });
  }

  Future get_logRound({required loadingTime, required inspectId}) async {
    var response = await connectApi.callApi_getData(
      values: {
        "inspect_id": inspectId,
      },
      ip: IP_Address.guard_IP_sever,
      path: "Get_guard_logs_today",
      loadingTime: loadingTime,
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
    if (response != null) {
      listLog_Round.assignAll(getLogs_Round.fromJson(response).data!);
      return response;
    } else {
      listLog_Round.value = [];
      return null;
    }
  }

  Future get_logImages({required log_Id}) async {
    var response = await connectApi.callApi_getData(
      values: {
        'guard_log_id': log_Id,
      },
      ip: IP_Address.guard_IP_sever,
      path: "Get_guard_log_image",
      loadingTime: 0,
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
    if (response != null) {
      List<Img>? listLog_Images = getLogs_img.fromJson(response).data;
      return listLog_Images;
    } else {
      return [];
    }
  }
}
