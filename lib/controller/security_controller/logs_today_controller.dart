// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/models/secarity_models/get_log_all.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/models/secarity_models/get_logs_img.dart';
import 'package:doormster/models/secarity_models/get_logs_round.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LogsTodayController extends GetxController {
  RxList<logRound> listLogsRound = <logRound>[].obs;
  RxList<logRound> filterLogsRound = <logRound>[].obs;
  RxList<logAll> listLogs = <logAll>[].obs;
  RxList<logAll> filterLogs = <logAll>[].obs;
  final formatDate = DateFormat('y-MM-dd');
  final now = DateTime.now();

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_logToday(
          loadingTime: 100,
          start_date: formatDate.format(now),
          end_date: formatDate.format(now));
    });
    super.onInit();
  }

  void searchData(String text) {
    listLogsRound.value = filterLogsRound.where((item) {
      var name = item.locationName!;
      return name.contains(text);
    }).toList();
  }

  Future get_logRound({required loadingTime, required inspectId}) async {
    var response = await connectApi.callApi_getData(
      values: {
        "inspect_id": inspectId,
      },
      ip: IP_Address.guard_IP_server,
      path: SecurityPath.GaurdLogsToday,
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
      listLogsRound.assignAll(getLogs_Round.fromJson(response).data!);
      return response;
    } else {
      listLogsRound.clear();
      return null;
    }
  }

  Future get_logToday(
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

  Future get_logImages({required log_Id}) async {
    var response = await connectApi.callApi_getData(
      values: {
        'guard_log_id': log_Id,
      },
      ip: IP_Address.guard_IP_server,
      path: SecurityPath.GaurdLogsImage,
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
