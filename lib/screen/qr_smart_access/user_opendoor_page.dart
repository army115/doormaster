// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doormster/controller/visitor_controller/door_user_controller.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:doormster/controller/visitor_controller/visitor_controller.dart';
import 'package:doormster/models/access_models/get_doors_user.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:geolocator/geolocator.dart';

class User_Opendoor extends StatefulWidget {
  User_Opendoor({Key? key}) : super(key: key);

  @override
  State<User_Opendoor> createState() => _User_OpendoorState();
}

class _User_OpendoorState extends State<User_Opendoor> {
  TextEditingController fieldText = TextEditingController();
  DoorUserController doorUserController = Get.put(DoorUserController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('open_door'.tr),
        ),
        body: Column(
          children: [
            doorUserController.filterDoor.length > 10
                ? Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                    child: Search_From(
                      title: 'search_door'.tr,
                      searchText: fieldText,
                      clear: () {
                        setState(() {
                          fieldText.clear();
                          doorUserController.listDoor
                              .assignAll(doorUserController.filterDoor);
                        });
                      },
                      changed: (value) {
                        doorUserController.searchData(value);
                      },
                    ))
                : Container(),
            Expanded(
              child: doorUserController.listDoor.isEmpty
                  ? Logo_Opacity(title: 'door_not_found'.tr)
                  : RefreshIndicator(
                      onRefresh: () async {},
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(
                            15,
                            doorUserController.filterDoor.length > 10 ? 0 : 15,
                            15,
                            110),
                        shrinkWrap: true,
                        primary: false,
                        itemCount: doorUserController.listDoor.length,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.only(bottom: 10),
                              elevation: 5,
                              child: doorsButton(
                                  '${doorUserController.listDoor[index].label}',
                                  'open_door'.tr,
                                  Icons.meeting_room_rounded,
                                  Get.textTheme.bodyLarge?.color,
                                  Get.theme.primaryColorDark,
                                  () => doorUserController.open_DoorUser(
                                      door_id: doorUserController
                                          .listDoor[index].value)));
                        },
                      ),
                    ),
            ),
          ],
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
