// ignore_for_file: use_build_context_synchronously, unused_import, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/widgets/drawer/drawer.dart';
import 'package:doormster/widgets/girdManu/grid_menu.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/controller/security_controller/round_now_controller.dart';
import 'package:doormster/models/secarity_models/get_round_now.dart';
import 'package:doormster/screen/security_guard/extra_page/extra_round_page.dart';
import 'package:doormster/screen/security_guard/log_page/report_logs_page.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/screen/security_guard/check_point_page.dart';
import 'package:doormster/screen/security_guard/round_check_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Security_Guard_Menu extends StatefulWidget {
  const Security_Guard_Menu({
    super.key,
  });

  @override
  State<Security_Guard_Menu> createState() => _Security_Guard_MenuState();
}

class _Security_Guard_MenuState extends State<Security_Guard_Menu> {
  final RoundNowController roundController = Get.put(RoundNowController());
  bool loading = false;
  String? companyId;

  Future onGoBack() async {
    roundController.get_roundNow(loadingTime: 0);
  }

  @override
  void dispose() {
    Get.delete<RoundNowController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Security Guard'),
        ),
        body: GridView.count(
          // scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(25),
          shrinkWrap: true,
          primary: false,
          childAspectRatio: 1.0,
          crossAxisCount: 2,
          // maxCrossAxisExtent: 300,
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
                        () => roundController.listRound.isEmpty
                            ? dialogOnebutton_Subtitle(
                                title: 'occur_error'.tr,
                                subtitle: 'check_later'.tr,
                                icon: Icons.warning_amber_rounded,
                                colorIcon: Colors.orange,
                                textButton: 'ok'.tr,
                                press: () {
                                  Get.back();
                                },
                                click: false,
                                backBtn: false,
                                willpop: false)
                            : checkInternet(
                                page: ScanQR_Check(
                                  name: 'check',
                                  roundName:
                                      roundController.listRound[0].inspectName,
                                  roundId:
                                      roundController.listRound[0].inspectId,
                                  roundStart:
                                      roundController.listRound[0].startDate,
                                  roundEnd:
                                      roundController.listRound[0].endDate,
                                  page: 'now',
                                  inspectDetail: roundController.inspectDetail,
                                  logs: roundController.logs,
                                ),
                                onGoBack: onGoBack)));
              },
            ),
            Grid_Menu(
                title: 'check_extra_round'.tr,
                icon: Icons.assignment_outlined,
                press: () {
                  checkInternet(
                      page: const Extra_Round(),
                      navigationId: NavigationIds.home,
                      onGoBack: onGoBack);
                }),
            Grid_Menu(
              title: 'register_point'.tr,
              icon: Icons.pin_drop_outlined,
              press: () {
                permissionCamere(
                  context,
                  () => permissionLocation(
                    context,
                    () => checkInternet(
                        page: const ScanQR_Check(
                          name: 'add',
                        ),
                        onGoBack: onGoBack),
                  ),
                );
              },
            ),
            Grid_Menu(
                title: 'view_checkpoint'.tr,
                icon: Icons.share_location_outlined,
                press: () {
                  checkInternet(
                      page: Check_Point(),
                      navigationId: NavigationIds.home,
                      onGoBack: onGoBack);
                }),
            Grid_Menu(
              title: 'report'.tr,
              icon: Icons.event_note,
              press: () {
                checkInternet(
                    page: Report_Logs(tapIndex: 0),
                    navigationId: NavigationIds.home,
                    onGoBack: onGoBack);
              },
            ),
            Grid_Menu(
                title: 'view_round'.tr,
                icon: Icons.edit_calendar_rounded,
                press: () {
                  checkInternet(
                      page: Round_Check(logs: roundController.logs),
                      navigationId: NavigationIds.home,
                      onGoBack: onGoBack);
                }),
          ],
        ),
      ),
    );
  }
}
