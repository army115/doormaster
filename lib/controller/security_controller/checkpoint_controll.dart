// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckPointController extends GetxController {
  RxList<checkPoint> listCheckpoint = <checkPoint>[].obs;
  RxList<checkPoint> filterCheckpoint = <checkPoint>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_checkPoint(loadingTime: 100);
    });
  }

  void searchData(String text) {
    listCheckpoint.value = filterCheckpoint.where((item) {
      var name = item.locationName!;
      return name.contains(text);
    }).toList();
  }

  Future get_checkPoint({required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_server,
      path: SecurityPath.CheckPoint,
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
    if (values != null) {
      listCheckpoint.assignAll(getCheckPoint.fromJson(values).data!);
      filterCheckpoint.assignAll(listCheckpoint);
    } else {
      listCheckpoint.clear();
      filterCheckpoint.clear();
    }
  }
}
