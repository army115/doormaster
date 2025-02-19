// ignore_for_file: invalid_use_of_protected_member, non_constant_identifier_names

import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/models/get_branch.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final BranchController branchController = Get.put(BranchController());

class BranchController extends GetxController {
  RxList<Data> listBranch = <Data>[].obs;
  RxString branch_Id = ''.obs;

  Future<dynamic> get_Branch({page}) async {
    var branchId = await SecureStorageUtils.readString('branch_Id');
    final values = await connectApi.callApi_getData(
        ip: IP_Address.emp_IP_server,
        path: MainPath.Branch,
        loadingTime: 0,
        showError: () {
          if (page != 'home') {
            error_Connected(() {
              Get.back();
            });
          }
        },
        showTimeout: () {
          if (page != 'home') {
            error_Timeout(() {
              Get.back();
            });
          }
        });
    if (values != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        listBranch.assignAll(getBranch.fromJson(values).data!);
        if (branchId == null) {
          await SecureStorageUtils.writeString(
              'branch_Id', listBranch[0].value!);
          branch_Id.value = listBranch[0].value!;
        } else {
          branch_Id.value = branchId.toString();
        }
      });
      return values['data'][0];
    } else if (branchId != null) {
      branch_Id.value = branchId.toString();
      return branch_Id.value;
    } else {
      listBranch.clear();
      return null;
    }
  }
}
