// ignore_for_file: sort_child_properties_last, prefer_const_constructors, unused_import
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button_outline.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/models/get_branch.dart';
import 'package:doormster/models/main_models/login_model.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/service/notify/notify_token.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'dart:convert' as convert;

class BottomSheetContent extends StatefulWidget {
  const BottomSheetContent({
    super.key,
  });

  @override
  BottomSheetContentState createState() => BottomSheetContentState();
}

class BottomSheetContentState extends State<BottomSheetContent> {
  List<Data> listBranch = branchController.listBranch;
  String branchId = branchController.branch_Id.value;

  @override
  Widget build(BuildContext context) {
    return Obx(() => connectApi.loading.isTrue || listBranch.isEmpty
        ? DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.3,
            builder: (context, scrollController) => Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.5,
            maxChildSize: 0.7,
            builder: (context, scrollController) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    toolbarHeight: 45,
                    automaticallyImplyLeading: false,
                    centerTitle: false,
                    title: SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                          physics: ClampingScrollPhysics(),
                          primary: false,
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                    height: 4,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                              listBranch.isEmpty
                                  ? Container()
                                  : Text('select_village'.tr)
                            ],
                          )),
                    ),
                    elevation: 0,
                  ),
                  backgroundColor: Colors.transparent,
                  body: Container(
                    child: listBranch.isEmpty
                        ? Center(
                            child: Text('check_connect'.tr,
                                style: TextStyle(color: Colors.white)),
                          )
                        : ListView.builder(
                            physics: ClampingScrollPhysics(),
                            controller: scrollController,
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
                                      branchController.branch_Id.value =
                                          listBranch[index].value!;
                                      Get.offAll(() => BottomBar());
                                    }
                                  },
                                )),
                  ),
                )));
  }
}
