// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_returning_null_for_void

import 'package:doormster/controller/estamp_controller/store_controller.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/models/estamp_models/get_logs_estamp.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EstampLogsController extends GetxController {
  final StoreController storeController = Get.find<StoreController>();
  RxList<LogData> logsEstamp = <LogData>[].obs;
  RxList<LogData> filterEstamp = <LogData>[].obs;
  RxInt countlogsEstamp = 0.obs;
  ScrollController scrollController = ScrollController();
  bool hasMore = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getEstampLogs(
          rowItem: 10, start_date: '', end_date: '', loadingTime: 500);
    });
    scrollController.addListener(getMoreData);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void searchData(String text) {
    logsEstamp.value = filterEstamp.where((item) {
      var name = item.plateNum;
      var createDate = item.createDate;
      return name.contains(text) || createDate.contains(text);
    }).toList();
  }

  void getMoreData() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (logsEstamp.value.length < countlogsEstamp.value) {
        hasMore = true;
        await Future.delayed(const Duration(milliseconds: 500));
        await getEstampLogs(
            rowItem: logsEstamp.value.length + 10,
            start_date: '',
            end_date: '',
            loadingTime: 0);
        hasMore = false;
      }
    }
  }

  Future getEstampLogs(
      {required rowItem,
      required start_date,
      required end_date,
      required loadingTime}) async {
    String branchId = branchController.branch_Id.value;
    String storeId = storeController.storeId.value;
    final values = await connectApi.callApi_getData(
        ip: IP_Address.stamp_IP_server,
        path: EstampPath.EstampLogs,
        loadingTime: loadingTime,
        values: {
          "page": 1,
          "row_perpage": rowItem,
          "branch_id": branchId,
          "store_id": storeId,
          "search_text": "",
          "start_date": start_date,
          "end_date": end_date
        },
        showError: () {
          error_Connected(() {
            Keys.home?.currentState
                ?.popUntil(ModalRoute.withName(Routes.estamp));
            Get.back();
          });
        },
        showTimeout: () {
          error_Timeout(() {
            Keys.home?.currentState
                ?.popUntil(ModalRoute.withName(Routes.estamp));
            Get.back();
          });
        });
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        logsEstamp.assignAll(GetLogsEstamp.fromJson(values).data);
        filterEstamp.assignAll(logsEstamp);
        countlogsEstamp.value = values['count'];
      });
      return values;
    } else {
      logsEstamp.clear();
      return null;
    }
  }
}
