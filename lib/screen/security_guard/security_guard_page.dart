// ignore_for_file: use_build_context_synchronously, unused_import, avoid_function_literals_in_foreach_calls

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/models/get_round_now.dart';
import 'package:doormster/screen/main_screen/test.dart';
import 'package:doormster/screen/security_guard/add_checkpoint_page.dart';
import 'package:doormster/screen/security_guard/check_in_page.dart';
import 'package:doormster/screen/security_guard/check_point_page.dart';
import 'package:doormster/screen/security_guard/extra_round_page.dart';
import 'package:doormster/screen/security_guard/report_logs_page.dart';
import 'package:doormster/screen/security_guard/round_check_page.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/controller/get_info.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  List<LogsList> logsList = [];
  List<String> listCheckpoint = [];
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
        getRoundNow roundlist = getRoundNow.fromJson(response.data);
        setState(() {
          listdata = roundlist.data!;
          logsList = listdata.isNotEmpty ? listdata[0].logsList! : [];
          loading = false;
          listCheckpoint = [];
        });

        //loop add list []
        logsList.forEach((value) => listCheckpoint.add(value.chekpointUUid!));
        print("listCheckpointId : ${listCheckpoint}");
      }
    } catch (error) {
      print(error);
      error_connected(context, () {
        homeKey.currentState?.popUntil(
          (route) => route.isFirst,
        );
        Navigator.of(context, rootNavigator: true).pop();
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      get_Info();
      _getRoundNow();
    });
  }

  @override
  void initState() {
    super.initState();
    get_Info();
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
      body: Container(
        child: GridView.extent(
          // scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(25),
          shrinkWrap: true,
          primary: false,
          childAspectRatio: 1.0,
          // crossAxisCount: 2,
          maxCrossAxisExtent: 300,
          crossAxisSpacing: 25,
          mainAxisSpacing: 25,
          children: [
            Grid_Menu(
              title: 'checkIn'.tr,
              icon: Icons.qr_code_scanner_rounded,
              press: () {
                permissionCamere(
                    context,
                    () => permissionLocation(
                        context,
                        () => listdata.isEmpty
                            ? dialogOnebutton_Subtitle(
                                context,
                                'found_error'.tr,
                                'check_later'.tr,
                                Icons.warning_amber_rounded,
                                Colors.orange,
                                'ok'.tr, () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              }, true, true)
                            : checkInternetOnGoBack(
                                context,
                                ScanQR_Check(
                                  name: 'check',
                                  roundName: listdata[0].roundName,
                                  roundId: listdata[0].roundUuid,
                                  roundStart: listdata[0].roundStart,
                                  roundEnd: listdata[0].roundEnd,
                                  checkpointId: listCheckpoint,
                                ),
                                true,
                                onGoBack)));
              },
            ),
            Grid_Menu(
                title: 'check_extra_round'.tr,
                icon: Icons.assignment_outlined,
                press: () {
                  checkInternetOnGoBack(
                      context, Extra_Round(), false, onGoBack);
                }),
            Grid_Menu(
              title: 'register_point'.tr,
              icon: Icons.pin_drop_outlined,
              press: () {
                permissionCamere(
                    context,
                    () => permissionLocation(
                        context,
                        () => checkInternetOnGoBack(
                            context,
                            ScanQR_Check(
                              name: 'add',
                            ),
                            true,
                            onGoBack)));
              },
            ),
            Grid_Menu(
                title: 'view_checkpoint'.tr,
                icon: Icons.share_location_outlined,
                press: () {
                  checkInternetOnGoBack(
                      context, Check_Point(), false, onGoBack);
                }),
            Grid_Menu(
              title: 'report'.tr,
              icon: Icons.event_note,
              press: () {
                checkInternetOnGoBack(context,
                    Report_Logs(type: 'home', tapIndex: 0), false, onGoBack);
              },
            ),
            Grid_Menu(
                title: 'view_round'.tr,
                icon: Icons.edit_calendar_rounded,
                press: () {
                  checkInternetOnGoBack(
                      context,
                      Round_Check(checkpointId: listCheckpoint),
                      false,
                      onGoBack);
                })
          ],
        ),
      ),
    );
  }
}
