// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final CheckPointController checkPointController =
    Get.put(CheckPointController());

class CheckPointController extends GetxController {
  RxList<checkPoint> list_Checkpoint = <checkPoint>[].obs;

  Future get_checkPoint({required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_sever,
      path: "get/checkpoint",
      loadingTime: loadingTime,
      showError: () {
        error_Connected(() {
          Get.back();
          Keys.home?.currentState?.popUntil(ModalRoute.withName('/security'));
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Get.back();
          Keys.home?.currentState?.popUntil(ModalRoute.withName('/security'));
        });
      },
    );
    if (values != null) {
      list_Checkpoint.assignAll(getCheckPoint.fromJson(values).data!);
    } else {
      list_Checkpoint.value = [];
    }
  }
}
