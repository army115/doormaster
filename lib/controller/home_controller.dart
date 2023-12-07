// ignore_for_file: invalid_use_of_protected_member

import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/models/get_ads_company.dart';
import 'package:doormster/models/get_menu.dart';
import 'package:doormster/models/profile_model.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  Rx<bool> loading = false.obs;
  RxList listMenu = <DataMenu>[].obs;
  RxList listAds = <DataAds>[].obs;
  var mobileRole;
  var companyId;
  var security;
  // var checkNet;

  @override
  void onInit() async {
    super.onInit();

    GetMenu();
  }

  @override
  void onClose() {
    GetMenu();
    super.onClose();
  }

  Future<void> GetMenu() async {
    SharedPreferences prefs;
    prefs = await SharedPreferences.getInstance();
    mobileRole = prefs.getInt('role') ?? 0;
    companyId = prefs.getString('companyId')!;
    security = prefs.getBool('security')!;
    // checkNet = await Connectivity().checkConnectivity();

    // log('net $checkNet');
    print('mobileRole: ${mobileRole}');
    print('companyId: ${companyId}');
    print('security: ${security}');

    try {
      loading.value = true;

      //call api menu
      var url = '${Connect_api().domain}/get/menumobile/$companyId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      //call api ads
      var urlAds = '${Connect_api().domain}/get/ads/$companyId';
      var responseAds = await Dio().get(
        urlAds,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200 && responseAds.statusCode == 200) {
        listMenu.value.assignAll(getMenu.fromJson(response.data).data!);
        listAds.value.assignAll(getAdsCompany.fromJson(responseAds.data).data!);
      }
    } catch (error) {
      print(error);
      // error_connected(context, () {
      //   // Navigator.of(context, rootNavigator: true).pop();
      //   Get.back();
      //   GetMenu();
      // });
      Get.defaultDialog(
        title: 'Dialog Title',
        middleText: 'This is the content of the dialog.',
        textConfirm: 'OK',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // Close the dialog
        },
      );
    } finally {
      loading.value = false;
    }
  }
}
