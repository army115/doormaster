// ignore_for_file: invalid_use_of_protected_member, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/models/company_models/get_ads_company.dart';
import 'package:doormster/models/main_models/get_menu.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

final HomeController Homecontroller = Get.put(HomeController());

class HomeController extends GetxController {
  Rx<bool> loading = false.obs;
  RxList listMenu = <DataMenu>[].obs;
  RxList listAds = <DataAds>[].obs;
  // var checkNet;

  @override
  void onInit() async {
    super.onInit();
    GetMenu();
  }

  @override
  void onClose() {
    listMenu.value.clear();
    listAds.value.clear();
    super.onClose();
  }

  Future<void> GetMenu() async {
    try {
      loading.value = true;

      await Future.delayed(Duration(milliseconds: 500));

      //   //call api menu
      //   var url = '${IP_Address.old_IP}get/menumobile/$companyId';
      //   var response = await Dio().get(
      //     url,
      //     options: Options(headers: {
      //       'Connect-type': 'application/json',
      //       'Accept': 'application/json',
      //     }),
      //   );

      //   //call api ads
      //   var urlAds = '${IP_Address.old_IP}get/ads/$companyId';
      //   var responseAds = await Dio().get(
      //     urlAds,
      //     options: Options(headers: {
      //       'Content-Type': 'application/json',
      //       'Accept': 'application/json',
      //     }),
      //   );

      //   if (response.statusCode == 200 && responseAds.statusCode == 200) {
      //     listMenu.value.assignAll(getMenu.fromJson(response.data).data!);
      //     listAds.value.assignAll(getAdsCompany.fromJson(responseAds.data).data!);
      //   }
      // } on DioError catch (error) {
      //   print(error);
      //   error_Connected(() {
      //     Get.back();
      //     GetMenu();
      //   });
    } finally {
      loading.value = false;
    }
  }
}
