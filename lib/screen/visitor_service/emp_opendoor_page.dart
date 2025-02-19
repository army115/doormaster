// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doormster/controller/visitor_controller/door_guard_Controller.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/button/buttonback_appbar.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:doormster/controller/main_controller/branch_controller.dart';
import 'package:doormster/controller/visitor_controller/visitor_controller.dart';
import 'package:doormster/models/access_models/get_door.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:geolocator/geolocator.dart';

class Emp_Opendoor extends StatefulWidget {
  final String codeNumber;
  const Emp_Opendoor({super.key, required this.codeNumber});

  @override
  State<Emp_Opendoor> createState() => _Emp_OpendoorState();
}

class _Emp_OpendoorState extends State<Emp_Opendoor> {
  TextEditingController fieldText = TextEditingController();
  DoorGuardController doorGuardController = Get.put(DoorGuardController());
  ScrollController scrollController = ScrollController();
  int count = 10;
  bool _hasMore = false;

  @override
  void initState() {
    scrollController.addListener(
      () async {
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !_hasMore) {
          if (mounted) {
            setState(() {
              _hasMore = true;
            });
          }
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            setState(() {
              count = count + 5;
              _hasMore = false;
            });
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.until((route) => route.isFirst);
        return false;
      },
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: Text('open_door'.tr),
            leading: button_back(() {
              Get.until((route) => route.isFirst);
            }),
          ),
          body: Column(
            children: [
              doorGuardController.filterDoor.length > 10
                  ? Container(
                      padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                      child: Search_From(
                        title: 'search_door'.tr,
                        searchText: fieldText,
                        clear: () {
                          setState(() {
                            fieldText.clear();
                            doorGuardController.listDoor =
                                doorGuardController.filterDoor;
                          });
                        },
                        changed: (value) {
                          doorGuardController.searchData(value);
                        },
                      ))
                  : Container(),
              Expanded(
                child: doorGuardController.listDoor.isEmpty
                    ? Logo_Opacity(title: 'door_not_found'.tr)
                    : RefreshIndicator(
                        onRefresh: () async {
                          doorGuardController.get_Door(loadingTime: 100);
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(
                              15,
                              doorGuardController.filterDoor.length > 10
                                  ? 0
                                  : 15,
                              15,
                              80),
                          controller: scrollController,
                          itemCount: count < doorGuardController.listDoor.length
                              ? count + (_hasMore ? 1 : 0)
                              : doorGuardController.listDoor.length,
                          itemBuilder: (context, index) {
                            if (index >= count) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CircleLoading(),
                              );
                            }
                            return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: EdgeInsets.symmetric(vertical: 5),
                                elevation: 5,
                                child: doorsButton(
                                    doorGuardController.listDoor[index].label!
                                        .split(': ')
                                        .last,
                                    'open_door'.tr,
                                    Icons.meeting_room_rounded,
                                    Get.textTheme.bodyLarge?.color,
                                    Theme.of(context).primaryColorDark, () {
                                  doorGuardController.open_Door(
                                    card_number: widget.codeNumber,
                                    door_id: doorGuardController
                                        .listDoor[index].value,
                                  );
                                }));
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget doorsButton(name, button, icon, textColor, color, press) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Text(name, style: Get.textTheme.bodySmall),
      trailing: ElevatedButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
        child: Wrap(
          children: [
            Icon(
              icon,
              color: textColor,
              size: 30,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              button,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        onPressed: press,
      ),
    );
  }
}
