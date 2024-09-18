// ignore_for_file: non_constant_identifier_names

import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/models/news_models/get_news.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

News_Controller news_controller = Get.put(News_Controller());

class News_Controller extends GetxController {
  RxList<Data> list_News = <Data>[].obs;
  RxList showtext = [].obs;

  Future get_News({required branch_id}) async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.guard_IP_sever,
        path: "get_announcement_table_admin_mobile",
        loadingTime: 100,
        values: {"branch_id": branch_id},
        showError: () {
          error_Connected(() {
            Get.back();
            get_News(branch_id: branch_id);
          }, click: true, back_btn: true);
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
            get_News(branch_id: branch_id);
          }, click: true, back_btn: true);
        });
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        list_News.assignAll(getNews.fromJson(values).data!);
        showtext.value = List<bool>.filled(list_News.length, false);
      });
    } else {
      list_News.value = [];
    }
  }
}
