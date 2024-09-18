// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously, deprecated_member_use

import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/calendar/calendar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_calendar.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/controller/security_controller/logs_controller.dart';
import 'package:doormster/models/secarity_models/get_log_all.dart';
import 'package:doormster/screen/security_guard/log_page/log_all/record_point_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logs_All extends StatefulWidget {
  final dateValue;
  final type;
  Logs_All({Key? key, this.dateValue, this.type});

  @override
  State<Logs_All> createState() => _Logs_AllState();
}

class _Logs_AllState extends State<Logs_All>
    with AutomaticKeepAliveClientMixin {
  TextEditingController fieldText = TextEditingController();
  TextEditingController searchText = TextEditingController();

  List<logAll> listLog1 = logsController.listLog_All;
  List<logAll> listLog2 = logsController.listLog_All;

  List<DateTime?> listDate = [DateTime.now()];
  String? startDate = '';
  String? endDate = '';

  void _searchData(String text) {
    setState(() {
      listLog1 = listLog2.where((item) {
        var name = item.inspectName!;
        var startDate = item.startDate!;
        var endDate = item.endDate!;
        return name.contains(text) ||
            startDate.contains(text) ||
            endDate.contains(text);
      }).toList();
    });
  }

  DateFormat formatDate = DateFormat('y-MM-dd');
  DateTime now = DateTime.now();
  String? dateNow;

  String createformat(fullDate, String type) {
    if (type == 'D') {
      DateFormat formatDate = DateFormat('dd-MM-y');
      return formatDate.format(DateTime.parse(fullDate));
    } else {
      DateFormat formatTime = DateFormat('HH:mm');
      return formatTime.format(DateTime.parse(fullDate));
    }
  }

  Future dateNowAll() async {
    startDate = formatDate.format(now);
    endDate = formatDate.format(now);
    dateNow = createformat(now.toString(), 'D');
    fieldText = TextEditingController(text: '${'pick_date'.tr} ($dateNow)');
    listDate = [now];
  }

  @override
  void initState() {
    super.initState();
    dateNowAll();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await logsController.get_logAll(
          start_date: startDate, end_date: endDate, loadingTime: 1);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                          Search_Calendar(
                            title: 'pick_date'.tr,
                            fieldText: fieldText,
                            ontap: () async {
                              await CalendarPicker_2Date(
                                      context: context, listDate: listDate)
                                  .then(
                                (value) async {
                                  if (value != null) {
                                    setState(() {
                                      startDate = value['startDate'];
                                      endDate = value['endDate'];
                                      fieldText.text = value['showDate'];
                                      listDate = value['listDate'];
                                    });
                                    await logsController.get_logAll(
                                        start_date: startDate,
                                        end_date: endDate,
                                        loadingTime: 100);
                                  }
                                },
                              );
                            },
                            clear: () async {
                              await logsController.get_logAll(
                                  start_date: formatDate.format(now),
                                  end_date: formatDate.format(now),
                                  loadingTime: 0);
                              setState(() {
                                dateNowAll();
                              });
                            },
                          ),
                          listLog2.length > 10
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
                                      searchText: searchText,
                                      clear: () {
                                        setState(() {
                                          searchText.clear();
                                          listLog1 = listLog2;
                                        });
                                      },
                                      changed: (value) {
                                        _searchData(value);
                                      },
                                    ),
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: listLog1.isEmpty
                          ? Logo_Opacity(title: 'data_not_found'.tr)
                          : RefreshIndicator(
                              onRefresh: () async {
                                logsController.get_logAll(
                                    start_date: startDate,
                                    end_date: endDate,
                                    loadingTime: 100);
                              },
                              child: ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 5),
                                  itemCount: listLog1.length,
                                  itemBuilder: ((context, index) {
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
                                          Get.to(() => Record_Point(
                                                logs: listLog1[index].logs,
                                                roundName: listLog1[index]
                                                            .inspectId ==
                                                        'INS000'
                                                    ? 'extra_round'.tr
                                                    : '${listLog1[index].inspectName}',
                                                roundStart: createformat(
                                                    listLog1[index].startDate!,
                                                    'T'),
                                                roundEnd: createformat(
                                                    listLog1[index].endDate!,
                                                    'T'),
                                                dateTime: fieldText.text
                                                            .contains(
                                                                'วันที่') ||
                                                        fieldText.text
                                                            .contains('Select')
                                                    ? dateNow
                                                    : fieldText.text,
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
                                                      '${'round'.tr} : ${listLog1[index].inspectId == 'INS000' ? 'extra_round'.tr : listLog1[index].inspectName}',
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
                                              listLog1[index].inspectId ==
                                                      'INS000'
                                                  ? Container()
                                                  : IntrinsicHeight(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              '${'start'.tr} : ${createformat(listLog1[index].startDate!, 'T')}'),
                                                          const VerticalDivider(
                                                              thickness: 1.5,
                                                              color:
                                                                  Colors.black,
                                                              width: 1),
                                                          Text(
                                                              '${'end'.tr} : ${createformat(listLog1[index].endDate!, 'T')}'),
                                                        ],
                                                      ),
                                                    ),
                                              listLog1[index].logs!.isNotEmpty
                                                  ? Text(
                                                      '${'record'.tr} ${listLog1[index].logs?.length} ${'list'.tr}',
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
