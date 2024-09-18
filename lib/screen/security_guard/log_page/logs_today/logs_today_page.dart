// ignore_for_file: use_build_context_synchronously
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/controller/security_controller/logs_controller.dart';
import 'package:doormster/controller/security_controller/round_controller.dart';
import 'package:doormster/models/secarity_models/get_log_all.dart';
import 'package:doormster/models/secarity_models/get_round_all.dart';
import 'package:doormster/screen/security_guard/log_page/logs_today/logs_point_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';

class Logs_Today extends StatefulWidget {
  const Logs_Today({super.key});

  @override
  State<Logs_Today> createState() => _Logs_TodayState();
}

class _Logs_TodayState extends State<Logs_Today>
    with AutomaticKeepAliveClientMixin {
  TextEditingController fieldText = TextEditingController();
  List<roundAll> listRound1 = roundController.listRound_All;
  List<roundAll> listRound2 = roundController.listRound_All;
  List<logAll> listlogs = logsController.listLog_Today;

  void _searchData(String text) {
    setState(() {
      listRound1 = listRound2.where((item) {
        var name = item.inspectName!;
        var startDate = item.startDate!;
        var endDate = item.endDate!;
        return name.contains(text) ||
            startDate.contains(text) ||
            endDate.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await roundController.get_roundAll(loadingTime: 100).then(
        (value) {
          if (value != null) {
            logsController.get_logToday(loadingTime: 100);
          }
        },
      );
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dateNow = DateFormat('dd-MM-y').format(DateTime.now());
    return Obx(
      () => Scaffold(
        body: connectApi.loading.isTrue
            ? Loading()
            : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
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
                        listRound2.length > 10
                            ? Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: DottedLine(
                                      direction: Axis.horizontal,
                                      alignment: WrapAlignment.center,
                                      lineLength: double.infinity,
                                      lineThickness: 2,
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
                                        listRound1 = listRound2;
                                      });
                                    },
                                    changed: (value) {
                                      _searchData(value);
                                    },
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  Expanded(
                      child: listRound1.isEmpty
                          ? Logo_Opacity(title: 'data_not_found'.tr)
                          : RefreshIndicator(
                              onRefresh: () async {
                                logsController.get_logToday(loadingTime: 100);
                              },
                              child: ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  itemCount: listRound1.length,
                                  itemBuilder: ((context, index) {
                                    bool outside = listlogs.any((element) =>
                                        element.inspectId == 'INS000');
                                    final logsPoint = listlogs.isEmpty
                                        ? 0
                                        : outside
                                            ? listlogs[index + 1].logs!.length
                                            : listlogs[index].logs!.length;
                                    final checkPoint =
                                        listRound1[index].inspectDetail!.length;

                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      elevation: 10,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          Get.to(() => Logs_Point(
                                                roundId:
                                                    listRound1[index].inspectId,
                                                roundName: listRound1[index]
                                                    .inspectName,
                                                roundStart: listRound1[index]
                                                    .startDate!
                                                    .substring(0, 5),
                                                roundEnd: listRound1[index]
                                                    .endDate!
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
                                                      '${'round'.tr} : ${listRound1[index].inspectName}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: Get.textTheme
                                                        .bodySmall?.color,
                                                  )
                                                ],
                                              ),
                                              IntrinsicHeight(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${'start'.tr} : ${listRound1[index].startDate!.substring(0, 5)}'),
                                                    const VerticalDivider(
                                                        thickness: 1.5,
                                                        color: Colors.black,
                                                        width: 1),
                                                    Text(
                                                        '${'end'.tr} : ${listRound1[index].endDate!.substring(0, 5)}'),
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
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark))
                                                      : Text(
                                                          '${'checked_incomplete'.tr} ($logsPoint/$checkPoint)',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .orange)),
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
