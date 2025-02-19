// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:doormster/controller/security_controller/logs_today_controller.dart';
import 'package:doormster/controller/security_controller/round_all_controller.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/screen/security_guard/log_page/logs_today/logs_point_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:doormster/widgets/dottedLine/dotted_line.dart';

class Logs_Today extends StatefulWidget {
  const Logs_Today({super.key});

  @override
  State<Logs_Today> createState() => _Logs_TodayState();
}

class _Logs_TodayState extends State<Logs_Today>
    with AutomaticKeepAliveClientMixin {
  final LogsTodayController logsController = Get.put(LogsTodayController());
  final RoundAllController roundController = Get.put(RoundAllController());
  TextEditingController fieldText = TextEditingController();
  final dateNow = DateFormat('dd-MM-y').format(DateTime.now());
  final now = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(
      () => Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
              child: Column(
                children: [
                  Card(
                    elevation: 10,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: textIcon(
                            '${'date_report'.tr} : $dateNow',
                            Icon(
                              Icons.event_note,
                              color: Theme.of(context).primaryColorDark,
                              size: 25,
                            ))),
                  ),
                  roundController.filterRound.length > 10
                      ? Column(
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: DottedLine(
                                height: 2,
                                dashColor: Colors.grey.shade600,
                                dashGapColor: Colors.white,
                              ),
                            ),
                            Search_From(
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
                            )
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
                child: roundController.listRound.isEmpty
                    ? Logo_Opacity(title: 'data_not_found'.tr)
                    : RefreshIndicator(
                        onRefresh: () async {
                          logsController.get_logToday(
                              loadingTime: 500,
                              start_date: logsController.formatDate.format(now),
                              end_date: logsController.formatDate.format(now));
                        },
                        child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            itemCount: roundController.listRound.length,
                            itemBuilder: ((context, index) {
                              bool outside = logsController.listLogs.any(
                                  (element) => element.inspectId == 'INS000');
                              final logsPoint = logsController.listLogs.isEmpty
                                  ? 0
                                  : outside
                                      ? logsController
                                          .listLogs[index + 1].logs!.length
                                      : logsController
                                          .listLogs[index].logs!.length;
                              final checkPoint = roundController
                                  .listRound[index].inspectDetail!.length;
                              log("checkPoint: $checkPoint");
                              log("logsPoint: $logsPoint");
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                elevation: 10,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Get.to(() => Logs_Point(
                                          roundId: roundController
                                              .listRound[index].inspectId,
                                          roundName: roundController
                                              .listRound[index].inspectName,
                                          roundStart: roundController
                                              .listRound[index].startDate!
                                              .substring(0, 5),
                                          roundEnd: roundController
                                              .listRound[index].endDate!
                                              .substring(0, 5),
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${'round'.tr} : ${roundController.listRound[index].inspectName}',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Get.theme.dividerColor,
                                            )
                                          ],
                                        ),
                                        IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${'start'.tr} : ${roundController.listRound[index].startDate!.substring(0, 5)}'),
                                              VerticalDivider(
                                                  thickness: 1.5,
                                                  color: Get.theme.dividerColor,
                                                  width: 1),
                                              Text(
                                                  '${'end'.tr} : ${roundController.listRound[index].endDate!.substring(0, 5)}'),
                                            ],
                                          ),
                                        ),
                                        logsPoint <= 0
                                            ? Text(
                                                '${'not_checked'.tr} ($logsPoint/$checkPoint)',
                                                style: const TextStyle(
                                                    color: Colors.red))
                                            : logsPoint >= checkPoint
                                                ? Text(
                                                    '${'checked_complete'.tr} ($logsPoint/$checkPoint)',
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .primaryColorDark))
                                                : Text(
                                                    '${'checked_incomplete'.tr} ($logsPoint/$checkPoint)',
                                                    style: const TextStyle(
                                                        color: Colors.orange)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })),
                      )),
          ],
        ),
      ),
    );
  }
}
