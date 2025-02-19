import 'dart:developer';

import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/models/access_models/get_door.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoorGuardController extends GetxController {
  RxList<Data> listDoor = <Data>[].obs;
  RxList<Data> filterDoor = <Data>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_Door(loadingTime: 100);
    });
  }

  void searchData(String text) {
    listDoor.value = filterDoor.where((item) {
      var label = item.label!.split(': ').last;
      return label.contains(text);
    }).toList();
  }

  Future get_Door({required loadingTime}) async {
    String branchId = branchController.branch_Id.value;
    final values = await connectApi.callApi_getData(
      ip: IP_Address.door_IP_server,
      path: VisitorPath.GuardDoor,
      loadingTime: loadingTime,
      values: {'branch_id': branchId},
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listDoor.assignAll(getDoor.fromJson(values).data!);
      });
    } else {
      listDoor.clear();
    }
  }

  Future open_Door({required door_id, required card_number}) async {
    String branchId = branchController.branch_Id.value;
    await connectApi.callApi_addData(
      ip: IP_Address.door_IP_server,
      path: VisitorPath.GuardOpenDoor,
      loadingTime: 100,
      values: {
        "branch_id": branchId,
        "door_id": door_id,
        "card_number": card_number,
      },
      showSuccess: () {
        snackbar(Colors.green, 'door_open_success'.tr,
            Icons.check_circle_outline_rounded);
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
}
