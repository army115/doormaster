// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_returning_null_for_void

import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  RxString storeId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getStoreInfo();
    });
  }

  Future getStoreInfo() async {
    String branchId = branchController.branch_Id.value;
    final values = await connectApi.callApi_getData(
        ip: IP_Address.stamp_IP_server,
        path: EstampPath.StoreInfo,
        loadingTime: 300,
        values: {"branch_id": branchId},
        showError: () {
          error_Connected(() {
            Get.back();
          });
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
          });
        });
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        storeId.value = values['store_id'];
        return values['store_id'];
      });
    } else {
      return null;
    }
  }
}
