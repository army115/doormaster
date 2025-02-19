// ignore_for_file: non_constant_identifier_names

import 'package:doormster/screen/qr_smart_access/visitor_detail_page.dart';
import 'package:doormster/screen/visitor_service/show_qrcode_page.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

CreateVisitorController createVisitorController = CreateVisitorController();

class CreateVisitorController {
  Future createVisitor_byUser({required value, required data_visitor}) async {
    debugPrint(value.toString());
    final data = await connectApi.callApi_addData(
      ip: IP_Address.emp_IP_server,
      path: VisitorPath.CreateVisitor,
      loadingTime: 100,
      values: value,
      showSuccess: () {
        snackbar(Colors.green, 'create_qrcode_success'.tr,
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
    if (data != null) {
      // debugPrint(data);
      String qr_code = data['qrcode'];
      Get.to(() => Visitor_Detail(
            visitordData: data_visitor,
            qr_code: qr_code,
          ));
    }
  }

  Future createVisitor_byGuard({required value, required data_visitor}) async {
    final data = await connectApi.callApi_addData(
      ip: IP_Address.emp_IP_server,
      path: VisitorPath.RegisterVisitor,
      loadingTime: 100,
      values: value,
      showSuccess: () {
        snackbar(Colors.green, 'create_qrcode_success'.tr,
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
    if (data != null) {
      var qr_code = data['qr_img'];
      var code_number = data['qrcode_no'];
      Get.to(() => Show_QRcode(
            visitordData: data_visitor,
            qr_code: qr_code,
            // code_number: code_number.toString(),
          ));
    }
  }
}
