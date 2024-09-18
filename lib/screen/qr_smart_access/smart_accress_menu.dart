// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_import

import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/screen/qr_smart_access/add_complaint_page.dart';
import 'package:doormster/screen/qr_smart_access/complaint_page.dart';
import 'package:doormster/screen/qr_smart_access/opendoor_page.dart';
import 'package:doormster/screen/qr_smart_access/scan_qrcode_page.dart';
import 'package:doormster/screen/qr_smart_access/sos_page.dart';
import 'package:doormster/screen/qr_smart_access/visitor_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    final status2 = await Permission.bluetoothScan.request();
    final status3 = await Permission.bluetoothConnect.request();
    if (status.isGranted && status2.isGranted && status3.isGranted) {
      checkInternet(page: Opendoor_Page(), navigationId: NavigationIds.home);
    } else {
      dialogOnebutton_Subtitle(
          title: 'allow_access'.tr,
          subtitle: 'need_access_device'.tr,
          icon: Icons.warning_amber_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () {
            Navigator.of(context, rootNavigator: true).pop();
            openAppSettings();
          },
          click: false,
          backBtn: true,
          willpop: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HIP Smart Community'),
      ),
      body:
          // Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Text(
          //           'contact_admin_approve'.tr,
          //           textAlign: TextAlign.center,
          //           style:
          //               TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
          //         ),
          //         Image.asset(
          //           'assets/images/Smart Community Logo.png',
          //           scale: 4.5,
          //           // opacity: AlwaysStoppedAnimation(0.7),
          //         ),
          //       ],
          //     ),
          //   )
          Container(
        child: GridView.count(
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
                checkInternet(page: Visitor_Page());
              },
            ),
            Grid_Menu(
              title: 'scan'.tr,
              icon: Icons.qr_code_scanner_rounded,
              press: () {
                permissionCamere(
                  context,
                  () => checkInternet(page: Scanner()),
                );
              },
            ),
            Grid_Menu(
              title: 'open_door'.tr,
              icon: Icons.meeting_room_rounded,
              press: () {
                checkInternet(
                    page: Opendoor_Page(), navigationId: NavigationIds.home);
              },
            ),
            Grid_Menu(
                title: 'emergancy_call'.tr,
                icon: Icons.phone_forwarded_rounded,
                press: () async {
                  await launch("tel:02-748-2191");
                  // await FlutterPhoneDirectCaller.callNumber(
                  //     '02-748-2191');
                }),
            Grid_Menu(
                title: 'complaint'.tr,
                icon: Icons.perm_phone_msg_rounded,
                press: () async {
                  checkInternet(
                      page: Complaint_Page(), navigationId: NavigationIds.home);
                }),
            Grid_Menu(
                title: 'SOS',
                icon: Icons.notification_important,
                press: () async {
                  checkInternet(
                      page: SOS_Page(), navigationId: NavigationIds.home);
                }),
          ],
        ),
      ),
    );
  }
}
