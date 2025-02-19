// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unused_import
import 'package:dio/dio.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/bottom_controller.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/button/button_close.dart';
import 'package:doormster/widgets/button/button_outline.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/models/get_branch.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'dart:convert' as convert;

class BottomSheet_Drawer extends StatefulWidget {
  const BottomSheet_Drawer({
    super.key,
  });

  @override
  BottomSheet_DrawerState createState() => BottomSheet_DrawerState();
}

class BottomSheet_DrawerState extends State<BottomSheet_Drawer> {
  List<Data> listBranch = branchController.listBranch;
  String branchId = branchController.branch_Id.value;

  @override
  Widget build(BuildContext context) {
    return Obx(() => connectApi.loading.isTrue
        ? CircleLoading(
            color: Colors.white,
          )
        : Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              toolbarHeight: 45,
              automaticallyImplyLeading: false,
              centerTitle: false,
              elevation: 0,
              title: SizedBox(
                width: double.infinity,
                child: listBranch.isEmpty
                    ? Container()
                    : Text('select_village'.tr),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(Icons.close),
                )
              ],
              bottom: AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                toolbarHeight: 1,
                elevation: 0,
              ),
            ),
            body: Container(
              child: listBranch.isEmpty
                  ? Center(
                      child: Text('check_connect'.tr,
                          style: TextStyle(color: Colors.white)),
                    )
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listBranch.length,
                      itemBuilder: (context, index) => ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            minLeadingWidth: 0,
                            minTileHeight: 0,
                            minVerticalPadding: 10,
                            leading: Icon(
                              Icons.home_work_sharp,
                              size: 20,
                              color: Colors.white,
                            ),
                            title: Text('${listBranch[index].label}',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            trailing: branchId == listBranch[index].value
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : SizedBox(),
                            onTap: () async {
                              if (branchId == listBranch[index].value) {
                                Get.back();
                                Get.back();
                              } else {
                                String branchIdSelect =
                                    listBranch[index].value!;
                                await SecureStorageUtils.writeString(
                                    'branch_Id', branchIdSelect);
                                branchController.branch_Id.value =
                                    branchIdSelect;
                                Get.back();
                                Get.back();
                              }
                            },
                          )),
            )));
  }
}
