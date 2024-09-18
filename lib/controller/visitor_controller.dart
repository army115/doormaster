// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, invalid_use_of_protected_member, non_constant_identifier_names

import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/access_models/get_house.dart';
import 'package:doormster/screen/qr_smart_access/visitor_detail_page.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:get/get.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';

final VisitorController visitorController = Get.put(VisitorController());

class VisitorController extends GetxController {
  RxList<Data> listHouse = <Data>[].obs;
  RxString qr_code = ''.obs;

  Future gethouse({required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.emp_IP_sever,
      path: "sel_house_Dropdown",
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        listHouse.assignAll(get_house.fromJson(values).data!);
      });
    } else {
      listHouse.value = [];
    }
  }

  Future create_Visitor({required value, required data_visitor}) async {
    final data = await connectApi.callApi_addData(
      ip: IP_Address.emp_IP_sever,
      path: "Create_visitor",
      loadingTime: 100,
      values: value,
      showSuccess: () {
        snackbar(Get.theme.primaryColor, 'create_qrcode_success'.tr,
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
      qr_code.value = data['qrcode'];
      Get.to(() => Visitor_Detail(
            visitordData: data_visitor,
          ));
    }
  }
}
