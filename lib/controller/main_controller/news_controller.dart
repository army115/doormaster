// ignore_for_file: non_constant_identifier_names

import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/models/news_models/get_news.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final NewsController newsController = NewsController();

class NewsController extends GetxController {
  RxList<Data> list_News = <Data>[].obs;
  RxList showtext = [].obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      get_News();
    });
  }

  Future get_News() async {
    String branchId = branchController.branch_Id.value;
    final values = await connectApi.callApi_getData(
        ip: IP_Address.guard_IP_server,
        path: MainPath.News,
        loadingTime: 100,
        values: {"branch_id": branchId},
        showError: () {
          error_Connected(() {
            Get.back();
            get_News();
          }, click: true, back_btn: true);
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
            get_News();
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
