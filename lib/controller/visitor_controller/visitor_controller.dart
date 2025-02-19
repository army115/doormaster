// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, invalid_use_of_protected_member, non_constant_identifier_names
import 'dart:developer';
import 'package:doormster/models/visitor_models/get_visitor.dart' as visitor;
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:get/get.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';

final VisitorController visitorController = Get.put(VisitorController());

class VisitorController extends GetxController {
  Rx<visitor.GetVisitor> visitorInfo = visitor.GetVisitor().obs;

  Future get_Visitor({required loadingTime, required qrcode}) async {
    int? qrcodeInt = int.tryParse(qrcode);
    final values = await connectApi.callApi_getData(
      ip: IP_Address.emp_IP_server,
      path: VisitorPath.Visitor,
      loadingTime: loadingTime,
      values: {"qrcode_no": qrcodeInt},
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
    if (values != null && values['data'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        visitorInfo.value = visitor.GetVisitor.fromJson(values);
      });
    } else {
      visitorInfo.value = visitor.GetVisitor();
    }
  }

  Future stamp_Visitor({required loadingTime, required qrcode}) async {
    final data = await connectApi.callApi_addData(
      ip: IP_Address.emp_IP_server,
      path: VisitorPath.StampVisitor,
      loadingTime: 100,
      values: {"qrcode_no": qrcode},
      showSuccess: () {
        dialogOnebutton(
            title: 'save_success'.tr,
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
    log(data);
  }
}
