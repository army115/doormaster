// ignore_for_file: non_constant_identifier_names, library_prefixes

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/screen/security_guard/log_page/report_logs_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final CheckInController checkInController = Get.put(CheckInController());

class CheckInController extends GetxController {
  RxList<checkPoint> CheckPoint = <checkPoint>[].obs;
  RxList<CheckpointList> CheckList = <CheckpointList>[].obs;

  RxString checkpointName = ''.obs;
  RxInt verify = 1.obs;

  Future get_Checklist({required checkpointId, required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.guard_IP_server,
      values: {"checkpoint_id": checkpointId},
      path: SecurityPath.CheckList,
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
    if (values['data'].isNotEmpty) {
      CheckPoint.assignAll(getCheckPoint.fromJson(values).data!);
      if (CheckPoint[0].verify == 0) {
        dialogOnebutton_Subtitle(
            title: 'checkpoint_found'.tr,
            subtitle: 'checkpoint_no_regis'.tr,
            icon: Icons.warning_amber_rounded,
            colorIcon: Colors.orange,
            textButton: 'ok'.tr,
            press: () {
              Get.until((route) => route.isFirst);
            },
            click: false,
            backBtn: false,
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
      CheckPoint.clear();
    }
  }

  Future guard_checkIn({required value, required logTab}) async {
    await connectApi.callApi_addformData(
      ip: IP_Address.guard_IP_server,
      path: SecurityPath.CheckIn,
      loadingTime: 100,
      values: value,
      showSuccess: () {
        dialogOnebutton(
            title: 'save_success'.tr,
            icon: Icons.check_circle_outline_rounded,
            colorIcon: Colors.green,
            textButton: 'ok'.tr,
            press: () {
              Get.to(() => Report_Logs(tapIndex: logTab));
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
