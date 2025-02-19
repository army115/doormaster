// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:doormster/models/secarity_models/get_round_all.dart';

// final RoundController roundController = Get.put(RoundController());

class RoundAllController extends GetxController {
  RxList<roundAll> listRound = <roundAll>[].obs;
  RxList<roundAll> filterRound = <roundAll>[].obs;
  RxList<InspectDetail> inspectDetail = <InspectDetail>[].obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_roundAll(loadingTime: 100);
    });
    super.onInit();
  }

  void searchData(String text) {
    listRound.value = filterRound.where((item) {
      var name = item.inspectName!;
      return name.contains(text);
    }).toList();
  }

  Future get_roundAll({required loadingTime}) async {
    final response = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_server,
      path: SecurityPath.Round,
      loadingTime: loadingTime,
      showError: () {
        error_Connected(() {
          Get.back();
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.security));
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Get.back();
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.security));
        });
      },
    );
    if (response != null) {
      listRound.assignAll(getRound_All.fromJson(response).data!);
      return response;
    } else {
      listRound.clear();
      return null;
    }
  }
}
