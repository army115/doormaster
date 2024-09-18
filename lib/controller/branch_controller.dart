// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/models/get_branch.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final BranchController branchController = Get.put(BranchController());

class BranchController extends GetxController {
  RxList<Data> listBranch = <Data>[].obs;
  RxString branch_Id = ''.obs;

  Future get_Branch() async {
    final values = await connectApi.callApi_getData(
        ip: IP_Address.emp_IP_sever,
        path: "Get_Branch_Employee",
        loadingTime: 0,
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
        listBranch.assignAll(getBranch.fromJson(values).data!);
        if (branch_Id == '') {
          branch_Id.value = listBranch[0].value!;
        }
      });
    } else {
      listBranch.value = [];
    }
  }
}
