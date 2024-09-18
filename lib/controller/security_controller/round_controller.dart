// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/models/secarity_models/get_round_all.dart' as all;
import 'package:doormster/models/secarity_models/get_round_now.dart';

final RoundController roundController = Get.put(RoundController());

class RoundController extends GetxController {
  RxList<roundNow> listRound_Now = <roundNow>[].obs;
  RxList<all.roundAll> listRound_All = <all.roundAll>[].obs;
  RxList<InspectDetail> inspectDetail = <InspectDetail>[].obs;
  RxList<Logs> logs = <Logs>[].obs;

  Future get_roundNow({required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_sever,
      path: "get_round_now",
      loadingTime: loadingTime,
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
      listRound_Now.assignAll(getRound_Now.fromJson(values).data!);
      if (listRound_Now.isNotEmpty) {
        inspectDetail.value = listRound_Now[0].inspectDetail!;
        logs.value = listRound_Now[0].logs!;
      }
    } else {
      listRound_Now.value = [];
    }
  }

  Future get_roundAll({required loadingTime}) async {
    final response = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_sever,
      path: "get_round",
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
    if (response != null) {
      listRound_All.assignAll(all.getRound_All.fromJson(response).data!);
      return response;
    } else {
      listRound_All.value = [];
      return null;
    }
  }
}
