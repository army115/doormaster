// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final AddCheckpointController addCheckpointController =
    Get.put(AddCheckpointController());

class AddCheckpointController extends GetxController {
  RxList<checkPoint> CheckPoint = <checkPoint>[].obs;
  RxList<CheckpointList> CheckList = <CheckpointList>[].obs;

  RxString checkpointName = ''.obs;
  RxInt verify = 0.obs;

  Future get_Checklist({required checkpointId, required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      values: {"checkpoint_id": checkpointId},
      ip: IP_Address.guard_IP_sever,
      path: "get/checkpointdetail",
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
    if (values['data'].isNotEmpty) {
      CheckPoint.assignAll(getCheckPoint.fromJson(values).data!);
      if (CheckPoint[0].verify == 1) {
        dialogOnebutton(
            title: 'checkpoint_regis'.tr,
            icon: Icons.warning_amber_rounded,
            colorIcon: Colors.orange,
            textButton: 'ok'.tr,
            press: () {
              Get.until((route) => route.isFirst);
            },
            click: false,
            willpop: false);
        verify.value = CheckPoint[0].verify!;
      } else {
        CheckList.value = CheckPoint[0].checkpointList!;
        checkpointName.value = CheckPoint[0].locationName!;
        verify.value = CheckPoint[0].verify!;
      }
    } else {
      dialogOnebutton_Subtitle(
          title: 'occur_error'.tr,
          subtitle: 'invalid_qrcode'.tr,
          icon: Icons.highlight_off_rounded,
          colorIcon: Colors.red,
          textButton: 'ok'.tr,
          press: () {
            Get.until((route) => route.isFirst);
          },
          click: false,
          backBtn: false,
          willpop: false);
      CheckPoint.value = [];
    }
  }

  Future add_Checkpoint(value) async {
    await connectApi.callApi_addData(
      ip: IP_Address.guard_IP_sever,
      path: "get/verifycheckpoint",
      loadingTime: 100,
      values: value,
      showSuccess: () {
        dialogOnebutton(
            title: 'register_success'.tr,
            icon: Icons.check_circle_outline_rounded,
            colorIcon: Colors.green,
            textButton: 'ok'.tr,
            press: () {
              Get.until((route) => route.isFirst);
            },
            click: false,
            willpop: false);
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
