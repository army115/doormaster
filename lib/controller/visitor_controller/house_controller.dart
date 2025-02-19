import 'package:doormster/models/access_models/get_house.dart';
import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HouseController extends GetxController {
  RxList<HouseData> listHouse = <HouseData>[].obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await get_House(loadingTime: 100);
    });
    super.onInit();
  }

  Future get_House({required loadingTime}) async {
    final values = await connectApi.callApi_getData(
      ip: IP_Address.emp_IP_server,
      path: VisitorPath.House,
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
        listHouse.assignAll(getHouse.fromJson(values).data!);
      });
    } else {
      listHouse.clear();
    }
  }
}
