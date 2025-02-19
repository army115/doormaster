// ignore_for_file: invalid_use_of_protected_member, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'dart:async';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/controller/main_controller/advert_controller.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/controller/main_controller/profile_controller.dart';
import 'package:doormster/models/company_models/get_ads_company.dart';
import 'package:doormster/models/main_models/get_menu.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

final HomeController homeController = Get.find<HomeController>();

class HomeController extends GetxController {
  RxBool loading = false.obs;
  RxInt roleId = 0.obs;
  RxList listAds = <DataAds>[].obs;
  RxList<GetMenu> listMenu = <GetMenu>[].obs;

  @override
  void onInit() {
    Get_Info();
    super.onInit();
  }

  Future<void> Get_Info() async {
    try {
      loading.value = true;
      await Future.delayed(const Duration(milliseconds: 500));
      var getRoleId = await SecureStorageUtils.readInt('role_id');
      roleId.value = getRoleId!;
      final responses = await Future.wait([
        getMenu(),
        profileController.get_Profile(loadingTime: 0, page: 'home'),
        branchController.get_Branch(page: 'home'),
        advert_controller.get_Advert(page: 'home'),
      ]);
      bool hasError = false;

      for (var response in responses) {
        if (response == null && !hasError) {
          hasError = true;
          error_Connected(() {
            Get_Info();
            Get.back();
          }, click: true, back_btn: true);
        }
      }
    } finally {
      loading.value = false;
    }
  }

  Future<dynamic> getMenu() async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.emp_IP_server,
        path: MainPath.Menu,
        loadingTime: 100,
        values: {"role_id": roleId.value},
        showError: () {},
        showTimeout: () {});
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        listMenu.assignAll(
          (values as List<dynamic>)
              .map((item) => GetMenu.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
      });
      return values[0];
    } else {
      return null;
    }
  }
}
