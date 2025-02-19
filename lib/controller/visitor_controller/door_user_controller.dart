// ignore_for_file: non_constant_identifier_names

import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/models/access_models/get_doors_user.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DoorUserController extends GetxController {
  RxList<DoorData> listDoor = <DoorData>[].obs;
  RxList<DoorData> filterDoor = <DoorData>[].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_DoorUser(loadingTime: 100);
    });
  }

  void searchData(String text) {
    listDoor.value = filterDoor.where((item) {
      var date = item.label!;
      return date.contains(text);
    }).toList();
  }

  Future get_DoorUser({required loadingTime}) async {
    String branchId = branchController.branch_Id.value;
    final values = await connectApi.callApi_getData(
      ip: IP_Address.stamp_IP_server,
      path: VisitorPath.UserDoor,
      loadingTime: loadingTime,
      values: {'branch_id': branchId},
      showError: () {
        error_Connected(() {
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.qrsmart));
          Get.until((route) => route.isFirst);
        });
      },
      showTimeout: () {
        error_Timeout(() {
          Keys.home?.currentState
              ?.popUntil(ModalRoute.withName(Routes.qrsmart));
          Get.until((route) => route.isFirst);
        });
      },
    );
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listDoor.assignAll(GetDoors.fromJson(values).data!);
        filterDoor.assignAll(listDoor);
      });
    } else {
      listDoor.clear();
      filterDoor.clear();
    }
  }

  Future open_DoorUser({required door_id}) async {
    String branchId = branchController.branch_Id.value;
    final values = await connectApi.callApi_getData(
      ip: IP_Address.stamp_IP_server,
      path: VisitorPath.UserOpenDoor,
      loadingTime: 100,
      values: {"branch_id": branchId, "door_id": door_id},
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
    if (values != null && values['status'] == 'true') {
      snackbar(Colors.green, 'door_open_success'.tr,
          Icons.check_circle_outline_rounded);
    } else if (values != null && values['status'] == 'false') {
      snackbar(Colors.red, 'door_open_fail'.tr, Icons.highlight_off_rounded);
    }
  }
}
