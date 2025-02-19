// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/models/secarity_models/get_log_all.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LogsAllController extends GetxController {
  RxList<logAll> listLogs = <logAll>[].obs;
  RxList<logAll> filterLogs = <logAll>[].obs;
  final formatDate = DateFormat('y-MM-dd');
  final now = DateTime.now();

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_logAll(
          loadingTime: 100,
          start_date: formatDate.format(now),
          end_date: formatDate.format(now));
    });
    super.onInit();
  }

  void searchData(String text) {
    listLogs.value = filterLogs.where((item) {
      var name = item.inspectName!;
      var startDate = item.startDate!;
      var endDate = item.endDate!;
      return name.contains(text) ||
          startDate.contains(text) ||
          endDate.contains(text);
    }).toList();
  }

  Future get_logAll(
      {required start_date, required end_date, required loadingTime}) async {
    await connectApi.callApi_getData(
      values: {
        'start_date': start_date,
        'end_date': end_date,
        "inspect_id": "",
      },
      ip: IP_Address.guard_IP_server,
      path: SecurityPath.GaurdLogsAll,
      loadingTime: loadingTime,
      showError: () {
        error_Connected(() {
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.security));
          Get.back();
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.security));
          Get.back();
        });
      },
    ).then((value) {
      if (value != null) {
        listLogs.assignAll(getLogs_All.fromJson(value).data!);
      } else {
        listLogs.clear();
      }
    });
  }
}
