// ignore_for_file: non_constant_identifier_names

import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/models/news_models/get_advert.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Advert_Controller advert_controller = Get.put(Advert_Controller());

class Advert_Controller extends GetxController {
  RxList<Data> list_Advert = <Data>[].obs;
  RxList showtext = [].obs;

  Future get_Advert({page}) async {
    String branchId = branchController.branch_Id.value;
    final values = await connectApi.callApi_getData(
        ip: IP_Address.door_IP_server,
        path: MainPath.Advert,
        loadingTime: 0,
        values: {'page': 1, 'row_perpage': 4, "branch_id": branchId},
        showError: () {
          if (page != 'home') {
            error_Connected(() {
              Get.back();
            }, click: true, back_btn: true);
          }
        },
        showTimeout: () {
          if (page != 'home') {
            error_Timeout(() {
              Get.back();
            }, click: true, back_btn: true);
          }
        });
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        list_Advert.assignAll(getAdvert.fromJson(values).data!);
        showtext.value = List<bool>.filled(list_Advert.length, false);
      });
      return values['data'][0];
    } else {
      list_Advert.clear();
    }
  }
}
