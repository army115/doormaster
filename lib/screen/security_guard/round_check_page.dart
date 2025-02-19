// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_import

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/controller/security_controller/round_all_controller.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/controller/security_controller/round_now_controller.dart';
import 'package:doormster/models/secarity_models/get_round_all.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Round_Check extends StatefulWidget {
  final logs;
  Round_Check({Key? key, this.logs}) : super(key: key);

  @override
  State<Round_Check> createState() => _Round_CheckState();
}

class _Round_CheckState extends State<Round_Check> {
  final RoundAllController roundController = Get.put(RoundAllController());
  TextEditingController fieldText = TextEditingController();

  ScrollController scrollController = ScrollController();
  int count = 10;
  bool _hasMore = false;

  Color? containerColor;
  Color? textColor;
  Color? line;

  DateTime now = DateTime.now();
  int round = 0;
  DateTime? timeStart;
  DateTime? timeEnd;

  Future _setColor() async {
    if (timeEnd!.isBefore(timeStart!)) {
      if (now.isAfter(timeStart!) ||
              now.isBefore(timeEnd!) ||
              now.isAtSameMomentAs(timeStart!)
          //  ||now.isAtSameMomentAs(timeEnd!)
          ) {
        containerColor = Theme.of(context).primaryColorDark;
        textColor = Theme.of(context).cardTheme.color;
        line = Theme.of(context).cardTheme.color;
        round = 1;
      } else {
        round = 0;
        containerColor = Theme.of(context).cardTheme.color;
        textColor = Theme.of(context).dividerColor;
        line = Colors.grey;
      }
    } else {
      if (now.isAfter(timeStart!) && now.isBefore(timeEnd!) ||
              now.isAtSameMomentAs(timeStart!)
          // || now.isAtSameMomentAs(timeEnd!)
          ) {
        containerColor = Theme.of(context).primaryColorDark;
        textColor = Theme.of(context).cardTheme.color;
        line = Theme.of(context).cardTheme.color;
        round = 1;
      } else {
        round = 0;
        containerColor = Theme.of(context).cardTheme.color;
        textColor = Theme.of(context).dividerColor;
        line = Colors.grey;
      }
    }
  }

  Future onGoBack() async {
    roundController.get_roundAll(loadingTime: 0);
  }

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('y-MM-dd').format(now);
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text('list_round'.tr)),
        body: Column(
          children: [
            roundController.filterRound.length > 10
                ? Container(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                    child: Search_From(
                      title: 'search_round'.tr,
                      searchText: fieldText,
                      clear: () {
                        setState(() {
                          fieldText.clear();
                          roundController.listRound
                              .assignAll(roundController.filterRound);
                        });
                      },
                      changed: (value) {
                        roundController.searchData(value);
                      },
                    ),
                  )
                : Container(),
            Expanded(
              child: roundController.listRound.isEmpty
                  ? Logo_Opacity(title: 'no_data'.tr)
                  : RefreshIndicator(
                      onRefresh: () async {
                        await roundController.get_roundAll(loadingTime: 100);
                      },
                      child: ListView.builder(
                          padding: roundController.listRound.length > 10
                              ? const EdgeInsets.fromLTRB(15, 0, 15, 10)
                              : const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                          controller: scrollController,
                          itemCount: count < roundController.listRound.length
                              ? count + (_hasMore ? 1 : 0)
                              : roundController.listRound.length,
                          itemBuilder: (context, index) {
                            if (index >= count) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CircleLoading(),
                              );
                            }
                            timeStart = DateTime.parse(
                                '$date ${roundController.listRound[index].startDate}');
                            timeEnd = DateTime.parse(
                                '$date ${roundController.listRound[index].endDate}');
                            _setColor();
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.symmetric(vertical: 5),
                              elevation: 10,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: containerColor,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    round == 1
                                        ? Column(
                                            children: [
                                              Text(
                                                'need_check'.tr,
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              Divider(
                                                  height: 15,
                                                  thickness: 1.5,
                                                  color: line),
                                            ],
                                          )
                                        : Container(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          '${'round'.tr} : ${roundController.listRound[index].inspectName}',
                                          style: TextStyle(color: textColor),
                                        )),
                                        round == 1
                                            ? button(
                                                'checkIn'.tr,
                                                Theme.of(context)
                                                    .cardTheme
                                                    .color, () {
                                                roundController.listRound[index]
                                                    .inspectDetail;
                                                permissionCamere(
                                                    context,
                                                    () => permissionLocation(
                                                        context,
                                                        () => checkInternet(
                                                            page: ScanQR_Check(
                                                                name: 'check',
                                                                roundId: roundController
                                                                    .listRound[
                                                                        index]
                                                                    .inspectId!,
                                                                roundName: roundController
                                                                    .listRound[
                                                                        index]
                                                                    .inspectName!,
                                                                roundStart:
                                                                    '${date}T${roundController.listRound[index].startDate!}',
                                                                roundEnd:
                                                                    '${date}T${roundController.listRound[index].endDate!}',
                                                                page: 'round',
                                                                inspectDetail: roundController
                                                                        .listRound[
                                                                            index]
                                                                        .inspectDetail ??
                                                                    [],
                                                                logs: widget
                                                                    .logs),
                                                            onGoBack:
                                                                onGoBack)));
                                              })
                                            : Container()
                                      ],
                                    ),
                                    Divider(
                                        height: 15,
                                        thickness: 1.5,
                                        color: line),
                                    IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${'start'.tr} : ${roundController.listRound[index].startDate!.substring(0, 5)}',
                                            style: TextStyle(color: textColor),
                                          ),
                                          VerticalDivider(
                                              thickness: 1.5,
                                              color: line,
                                              width: 1),
                                          Text(
                                            '${'end'.tr} : ${roundController.listRound[index].endDate!.substring(0, 5)}',
                                            style: TextStyle(color: textColor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget button(name, color, press) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      onPressed: press,
      child: Text(
        name,
        style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).dividerColor,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
