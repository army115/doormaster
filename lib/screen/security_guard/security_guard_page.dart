// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/models/get_round.dart';
import 'package:doormster/screen/main_screen/test.dart';
import 'package:doormster/screen/security_guard/check_in_page.dart';
import 'package:doormster/screen/security_guard/check_point_page.dart';
import 'package:doormster/screen/security_guard/record_check_page.dart';
import 'package:doormster/screen/security_guard/round_check_page.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/service/check_connected.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  String? companyId;
  List<Data> listdata = [];
  DateTime now = DateTime.now();
  DateFormat format = DateFormat("HH:mm");

  Future _getRoundNow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    now = DateTime.now();
    print('companyId: ${companyId}');

    try {
      setState(() {
        loading = true;
      });

      //call api
      var url = '${Connect_api().domain}/getRoundNow/$companyId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getRound checklist = getRound.fromJson(response.data);
        setState(() {
          print(response.data);
          listdata = checklist.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      // await Future.delayed(Duration(milliseconds: 500));
      // dialogOnebutton_Subtitle(
      //     context,
      //     'พบข้อผิดพลาด',
      //     'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
      //     Icons.warning_amber_rounded,
      //     Colors.orange,
      //     'ตกลง', () {
      //   homeKey.currentState?.popUntil(ModalRoute.withName('/security'));
      //   Navigator.of(context, rootNavigator: true).pop();
      // }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getRoundNow();
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
          padding: EdgeInsets.all(25),
          child: Column(children: [
            GridView.count(
              // scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              childAspectRatio: 1.0,
              crossAxisCount: 2,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
              children: [
                Grid_Menu(
                  title: 'บันทึกจุดตรวจ',
                  icon: Icons.qr_code_scanner_rounded,
                  press: () {
                    permissionCamere(
                        context,
                        () => permissionLocation(
                            context,
                            () => checkInternet(
                                context,
                                ScanQR_Check(
                                  name: 'check',
                                  roundName: listdata[0].roundName,
                                  roundId: listdata[0].roundUuid,
                                  roundStart: listdata[0].roundStart,
                                  roundEnd: listdata[0].roundEnd,
                                ),
                                true)));
                  },
                ),
                Grid_Menu(
                  title: 'ลงทะเบียนจุดตรวจ',
                  icon: Icons.pin_drop_outlined,
                  press: () {
                    permissionCamere(
                        context,
                        () => permissionLocation(
                            context,
                            () => checkInternet(
                                context,
                                ScanQR_Check(
                                  name: 'add',
                                ),
                                true)));
                  },
                ),
                Grid_Menu(
                    title: 'รอบเดินตรวจ',
                    icon: Icons.edit_calendar_rounded,
                    press: () {
                      checkInternet(context, Round_Check(), false);
                    }),
                Grid_Menu(
                    title: 'จุดเดินตรวจ',
                    icon: Icons.share_location_outlined,
                    press: () {
                      checkInternet(context, Check_Point(), false);
                    }),
                Grid_Menu(
                  title: 'ดูรายการบันทึกการตรวจ',
                  icon: Icons.event_note,
                  press: () {
                    checkInternet(context, Record_Check(type: 'home'), false);
                  },
                ),
                Grid_Menu(
                    title: 'บันทึกการตรวจนอกรอบ',
                    icon: Icons.assignment_outlined,
                    press: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) => Scaffold(
                                  appBar: AppBar(
                                    title: Text('บันทึกการตรวจนอกรอบ'),
                                  ),
                                  body: Logo_Opacity(title: 'ไม่มีข้อมูล'),
                                )
                            // Check_In(
                            //   timeCheck: DateTime.now(),
                            //   checkpointId:
                            //       'd05154cb-8787-40b1-acdb-13f62303859e',
                            //   lat: 13.69521967419439,
                            //   lng: 100.64172377200555,
                            // ),
                            ),
                      );
                    }),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
