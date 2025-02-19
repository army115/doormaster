// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:doormster/controller/calendar_controller.dart';
import 'package:doormster/controller/security_controller/logs_all_controller.dart';
import 'package:doormster/utils/date_time_utils.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/button/buttonback_appbar.dart';
import 'package:doormster/widgets/calendar/calendar.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/widgets/searchbar/search_calendar.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/controller/security_controller/logs_today_controller.dart';
import 'package:doormster/models/secarity_models/get_log_all.dart';
import 'package:doormster/screen/security_guard/log_page/log_all/record_point_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/widgets/dottedLine/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Logs_All extends StatefulWidget {
  final dateValue;
  final type;
  Logs_All({Key? key, this.dateValue, this.type});

  @override
  State<Logs_All> createState() => _Logs_AllState();
}

class _Logs_AllState extends State<Logs_All>
    with AutomaticKeepAliveClientMixin {
  final LogsAllController logsController = Get.put(LogsAllController());
  final CalendarController calendarController = Get.put(CalendarController());
  TextEditingController searchText = TextEditingController();

  DateFormat formatDate = DateFormat('y-MM-dd');
  DateTime now = DateTime.now();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    calendarController.resetToDateNow();
    super.initState();
  }

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
                SearchCalendar(
                  title: 'pick_date'.tr,
                  onTap: () async {
                    await CalendarPicker_2Date(
                            context: context,
                            listDate: calendarController.listDate.value)
                        .then(
                      (value) async {
                        if (value != null) {
                          calendarController.updateDates(value);
                          await logsController.get_logAll(
                              start_date: calendarController.startDate.value,
                              end_date: calendarController.endDate.value,
                              loadingTime: 500);
                        }
                      },
                    );
                  },
                  onClear: () async {
                    await logsController.get_logAll(
                        start_date: formatDate.format(now),
                        end_date: formatDate.format(now),
                        loadingTime: 0);
                    calendarController.resetToDateNow();
                  },
                ),
                logsController.filterLogs.length > 10
                    ? Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DottedLine(
                              height: 2,
                              dashColor: Colors.grey.shade600,
                              dashGapColor: Colors.white,
                            ),
                          ),
                          Search_From(
                            title: 'search_round'.tr,
                            searchText: searchText,
                            clear: () {
                              setState(() {
                                searchText.clear();
                                logsController.listLogs
                                    .assignAll(logsController.filterLogs);
                              });
                            },
                            changed: (value) {
                              logsController.searchData(value);
                            },
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Expanded(
            child: logsController.listLogs.isEmpty
                ? Logo_Opacity(title: 'data_not_found'.tr)
                : RefreshIndicator(
                    onRefresh: () async {
                      logsController.get_logAll(
                          start_date: calendarController.startDate.value,
                          end_date: calendarController.endDate.value,
                          loadingTime: 500);
                    },
                    child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                        itemCount: logsController.listLogs.length,
                        itemBuilder: ((context, index) {
                          final date =
                              DateTimeUtils.format(now.toString(), 'D');
                          final startTime = DateTimeUtils.format(
                              logsController.listLogs[index].startDate!, 'T');
                          final endTime = DateTimeUtils.format(
                              logsController.listLogs[index].endDate!, 'T');
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 10,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.to(() => Record_Point(
                                      logs: logsController.listLogs[index].logs,
                                      roundName: logsController
                                                  .listLogs[index].inspectId ==
                                              'INS000'
                                          ? 'extra_round'.tr
                                          : '${logsController.listLogs[index].inspectName}',
                                      roundStart: startTime,
                                      roundEnd: endTime,
                                      dateTime: calendarController
                                                  .fieldText.value.text
                                                  .contains('วันที่') ||
                                              calendarController
                                                  .fieldText.value.text
                                                  .contains('Select')
                                          ? date
                                          : calendarController
                                              .fieldText.value.text,
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${'round'.tr} : ${logsController.listLogs[index].inspectId == 'INS000' ? 'extra_round'.tr : logsController.listLogs[index].inspectName}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: Get.theme.dividerColor,
                                        )
                                      ],
                                    ),
                                    logsController.listLogs[index].inspectId ==
                                            'INS000'
                                        ? Container()
                                        : IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    '${'start'.tr} : $startTime'),
                                                VerticalDivider(
                                                    thickness: 1.5,
                                                    color:
                                                        Get.theme.dividerColor,
                                                    width: 1),
                                                Text('${'end'.tr} : $endTime'),
                                              ],
                                            ),
                                          ),
                                    logsController
                                            .listLogs[index].logs!.isNotEmpty
                                        ? Text(
                                            '${'record'.tr} ${logsController.listLogs[index].logs?.length} ${'list'.tr}',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          )
                                        : Text(
                                            'no_record'.tr,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
          ),
        ],
      )),
    );
  }
}
