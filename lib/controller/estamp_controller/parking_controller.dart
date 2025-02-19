// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names, avoid_returning_null_for_void
import 'dart:developer';

import 'package:doormster/controller/estamp_controller/store_controller.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/models/estamp_models/get_estamp.dart';
import 'package:doormster/models/estamp_models/get_parking.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParkingController extends GetxController {
  final StoreController storeController = Get.find<StoreController>();
  Rx<getParking> parkingInfo = getParking().obs;
  RxList<getEstamp> Estamp = <getEstamp>[].obs;
  RxList<EstampAvail> EstampHistory = <EstampAvail>[].obs;
  RxBool isEstamp = false.obs;

  Future get_Parking({required String parkingId}) async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.stamp_IP_server,
        path: EstampPath.Parking,
        loadingTime: 800,
        values: {"parking_id": parkingId, "is_store": 1},
        showError: () {
          error_Connected(() {
            Get.until((route) => route.isFirst);
          });
        },
        showTimeout: () {
          error_Timeout(() {
            Get.until((route) => route.isFirst);
          });
        });
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        parkingInfo.value = getParking.fromJson(values);
        EstampHistory.assignAll(parkingInfo.value.estampAvail!);
        return values;
      });
    } else {
      parkingInfo.value = getParking();
      return null;
    }
  }

  Future get_Estamp({required String parkingId}) async {
    isEstamp.value = true;
    String branchId = branchController.branch_Id.value;
    String storeId = storeController.storeId.value;
    final values = await connectApi.callApi_getData(
        ip: IP_Address.stamp_IP_server,
        path: EstampPath.EstampDiscounts,
        loadingTime: 0,
        values: {
          "search_text": "",
          "parking_id": parkingId,
          "branch_id": branchId,
          "store_id": storeId
        },
        showError: () {
          error_Connected(() {
            Get.back();
            Get.back();
          });
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
            Get.back();
          });
        });
    if (values != null) {
      log(values.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Estamp.assignAll(
          (values as List<dynamic>)
              .map((item) => getEstamp.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
      });
      isEstamp.value = false;
      return values;
    } else {
      isEstamp.value = false;
      Estamp.clear();
      return null;
    }
  }
}
