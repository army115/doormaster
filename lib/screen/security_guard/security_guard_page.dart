import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/screen/security_guard/check_point_page.dart';
import 'package:doormster/screen/security_guard/record_check_page.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/service/check_connected.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security_Guard extends StatefulWidget {
  Security_Guard({Key? key});
  static const String route = '/security';

  @override
  State<Security_Guard> createState() => _Security_GuardState();
}

class _Security_GuardState extends State<Security_Guard> {
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
    final permission = await Permission.location.request();
    if (permission.isGranted) {
      checkInternet(context, ScanQR_Check());
    } else {
      dialogOnebutton_Subtitle(
          context,
          'อนุญาตการเข้าถึง',
          'จำเป็นต้องเข้าถึงตำแหน่งอุปกรณ์ของคุณ',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        openAppSettings();
        Navigator.of(context, rootNavigator: true).pop();
      }, false, true);
    }
  }

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Security Guard'),
        // leading: IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     }),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(children: [
            GridView.count(
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              childAspectRatio: 1.0,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                Grid_Menu(
                  title: 'บันทึกจุดตรวจ',
                  icon: Icons.qr_code_scanner_rounded,
                  press: () {
                    requestLocationPermission();
                  },
                ),
                Grid_Menu(
                  title: 'ลงทะเบียนจุดตรวจ',
                  icon: Icons.pin_drop_outlined,
                  press: () {
                    requestLocationPermission();
                  },
                ),
                Grid_Menu(
                  title: 'ดูรายการบันทึกเหตุการณ์',
                  icon: Icons.event_note,
                  press: () {
                    checkInternet(context, Record_Check());
                  },
                ),
                Grid_Menu(
                    title: 'บันทึกเหตุการณ์เพิ่มเติม',
                    icon: Icons.assignment_outlined,
                    press: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute<void>(
                      //     builder: (BuildContext context) => Check_Point(
                      //         checkpointId:
                      //             'd05154cb-8787-40b1-acdb-13f62303859e',
                      //         timeCheck: DateTime.now(),
                      //         lat: 13.695287,
                      //         lng: 100.6417099),
                      //   ),
                      // );
                    }),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
