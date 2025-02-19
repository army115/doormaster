// ignore_for_file: prefer_const_declarations, unused_local_variable, prefer_const_constructors, unused_import
import 'dart:convert';
import 'dart:ffi';
import 'package:doormster/widgets/bottombar/bottom_controller.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:doormster/widgets/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Notification_Page extends StatefulWidget {
  const Notification_Page({super.key});

  @override
  State<Notification_Page> createState() => _Notification_PageState();
}

class _Notification_PageState extends State<Notification_Page>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text('notification'.tr),
          // leading: IconButton(
          //     icon: Icon(Icons.menu),
          //     onPressed: () {
          //       Scaffold.of(context).openDrawer();
          //     }),
        ),
        body: Center(
          child: bottomController.notifications.isEmpty
              ? Logo_Opacity(title: 'no_notification'.tr)
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 80),
                  itemCount: bottomController.notifications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text('${bottomController.notifications[index]}'),
                        onTap: () {
                          // Get.toNamed()
                        },
                      ),
                    );
                  }),
        ),
      );
    });
  }
}
