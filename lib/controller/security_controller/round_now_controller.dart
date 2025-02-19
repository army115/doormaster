// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/models/secarity_models/get_round_now.dart';

class RoundNowController extends GetxController {
  RxList<roundNow> listRound = <roundNow>[].obs;
  RxList<InspectDetail> inspectDetail = <InspectDetail>[].obs;
  RxList<Logs> logs = <Logs>[].obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      get_roundNow(loadingTime: 100);
    });
    super.onInit();
  }

  Future get_roundNow({required loadingTime}) async {
    String branchId = branchController.branch_Id.value;
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_server,
      path: SecurityPath.RoundNow,
      loadingTime: loadingTime,
      values: {"branch_id": branchId},
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
      listRound.assignAll(getRound_Now.fromJson(values).data!);
      if (listRound.isNotEmpty) {
        inspectDetail.value = listRound[0].inspectDetail!;
        logs.value = listRound[0].logs!;
      }
    } else {
      listRound.clear();
    }
  }
}
