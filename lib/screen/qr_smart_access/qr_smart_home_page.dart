// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_import

import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/screen/qr_smart_access/opendoor_page.dart';
import 'package:doormster/screen/qr_smart_access/scan_qrcode_page.dart';
import 'package:doormster/screen/qr_smart_access/visitor_page.dart';
import 'package:doormster/controller/get_info.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class QRSmart_HomePage extends StatefulWidget {
  QRSmart_HomePage({
    Key? key,
  }) : super(key: key);
  static const String route = '/qrsmart';

  @override
  State<QRSmart_HomePage> createState() => _QRSmart_HomePageState();
}

class _QRSmart_HomePageState extends State<QRSmart_HomePage> {
  bool loading = false;

  var mobileRole;
  Future _getRole() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileRole = await prefs.getInt('role') ?? "";
    print('mobileRole: ${mobileRole}');
    setState(() {
      loading = false;
    });
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    final status2 = await Permission.bluetoothScan.request();
    final status3 = await Permission.bluetoothConnect.request();
    print("${status}");
    print("${status2}");
    print("${status3}");
    if (status.isGranted && status2.isGranted && status3.isGranted) {
      checkInternet(context, Opendoor_Page(), false);
    } else {
      dialogOnebutton_Subtitle(
          context,
          'allow_access'.tr,
          'need_access_device'.tr,
          Icons.warning_amber_rounded,
          Colors.orange,
          'ok'.tr, () {
        Navigator.of(context, rootNavigator: true).pop();
        openAppSettings();
      }, false, true);
    }
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      get_Info();
    });
  }

  @override
  void initState() {
    super.initState();
    get_Info();
    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('HIP Smart Community'),
        // leading: IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {
        //       Navigator.pop(context);
        //       Scaffold.of(context).openDrawer();
        //     }),
      ),
      body: mobileRole == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'contact_admin_approve'.tr,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                  ),
                  Image.asset(
                    'assets/images/Smart Community Logo.png',
                    scale: 4.5,
                    // opacity: AlwaysStoppedAnimation(0.7),
                  ),
                ],
              ),
            )
          : Container(
              child: GridView.extent(
                padding: EdgeInsets.all(25),
                // scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                childAspectRatio: 1.0,
                // crossAxisCount: 2,
                maxCrossAxisExtent: 300,
                crossAxisSpacing: 25,
                mainAxisSpacing: 25,
                children: [
                  Grid_Menu(
                    title: 'visitor'.tr,
                    icon: Icons.person,
                    press: () {
                      checkInternetOnGoBack(
                          context, Visitor_Page(), true, onGoBack);
                    },
                  ),
                  Grid_Menu(
                    title: 'scan'.tr,
                    icon: Icons.qr_code_scanner_rounded,
                    press: () {
                      permissionCamere(
                        context,
                        () => checkInternet(context, Scanner(), true),
                      );
                    },
                  ),
                  Grid_Menu(
                    title: 'open_door'.tr,
                    icon: Icons.meeting_room_rounded,
                    press: () {
                      checkInternetOnGoBack(
                          context, Opendoor_Page(), false, onGoBack);
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
                ],
              ),
              // SizedBox(height: 20),
              // Buttons(
              //     title: 'test',
              //     press: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: ((context) => Test())));
              //     })
            ),
    );
  }
}
