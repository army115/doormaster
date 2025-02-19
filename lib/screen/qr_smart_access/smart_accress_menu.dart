// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_import
import 'package:doormster/screen/qr_smart_access/list_visitor_page.dart';
import 'package:doormster/screen/qr_smart_access/scan_qr_visitor.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/widgets/drawer/drawer.dart';
import 'package:doormster/widgets/girdManu/grid_menu.dart';
import 'package:doormster/screen/qr_smart_access/add_complaint_page.dart';
import 'package:doormster/screen/qr_smart_access/complaint_page.dart';
import 'package:doormster/screen/qr_smart_access/user_opendoor_page.dart';
import 'package:doormster/screen/qr_smart_access/sos_page.dart';
import 'package:doormster/screen/qr_smart_access/create_visitor_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class Smart_Accress_Menu extends StatefulWidget {
  const Smart_Accress_Menu({
    super.key,
  });

  @override
  State<Smart_Accress_Menu> createState() => _Smart_Accress_MenuState();
}

class _Smart_Accress_MenuState extends State<Smart_Accress_Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HIP Smart Community'),
      ),
      body: GridView.count(
        padding: EdgeInsets.all(25),
        // scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        childAspectRatio: 1.0,
        crossAxisCount: 2,
        // maxCrossAxisExtent: 300,
        crossAxisSpacing: 25,
        mainAxisSpacing: 25,
        children: [
          Grid_Menu(
            title: 'visitor'.tr,
            icon: Icons.person,
            press: () {
              checkInternet(page: Create_Visitor());
            },
          ),
          Grid_Menu(
            title: 'scan'.tr,
            icon: Icons.qr_code_scanner_rounded,
            press: () {
              permissionCamere(
                context,
                () {
                  checkInternet(page: ScanQrVisitor());
                },
              );
            },
          ),
          Grid_Menu(
            title: 'open_door'.tr,
            icon: Icons.meeting_room_rounded,
            press: () {
              checkInternet(
                  page: User_Opendoor(), navigationId: NavigationIds.home);
            },
          ),
          // Grid_Menu(
          //   title: 'List visitor'.tr,
          //   icon: Icons.perm_contact_calendar_rounded,
          //   press: () {
          //     checkInternet(
          //         page: ListVisitor(), navigationId: NavigationIds.home);
          //   },
          // ),
          Grid_Menu(
              title: 'complaint'.tr,
              icon: Icons.perm_phone_msg_rounded,
              press: () {
                checkInternet(
                    page: Complaint_Page(), navigationId: NavigationIds.home);
              }),
          Grid_Menu(
              title: 'SOS',
              icon: Icons.notification_important,
              press: () {
                checkInternet(
                    page: SOS_Page(), navigationId: NavigationIds.home);
              }),
        ],
      ),
    );
  }
}
