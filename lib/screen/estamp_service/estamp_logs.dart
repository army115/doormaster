import 'package:doormster/controller/calendar_controller.dart';
import 'package:doormster/controller/estamp_controller/estamp_logs_controller.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:flutter/material.dart';
import 'package:doormster/widgets/calendar/calendar.dart';
import 'package:doormster/widgets/searchbar/search_calendar.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/dottedLine/dotted_line.dart';
import 'package:get/get.dart';

class Estamp_Logs extends StatefulWidget {
  const Estamp_Logs({super.key});

  @override
  State<Estamp_Logs> createState() => _Estamp_LogsState();
}

class _Estamp_LogsState extends State<Estamp_Logs> {
  final EstampLogsController estampLogsController =
      Get.put(EstampLogsController());
  final CalendarController calendarController = Get.put(CalendarController());
  TextEditingController searchText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('E-Stamp logs'),
        ),
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
                          .then((value) async {
                        if (value != null) {
                          calendarController.updateDates(value);
                          await estampLogsController.getEstampLogs(
                              rowItem: 10,
                              start_date: calendarController.startDate.value,
                              end_date: calendarController.endDate.value,
                              loadingTime: 100);
                        }
                      });
                    },
                    onClear: () async {
                      await estampLogsController.getEstampLogs(
                          rowItem: 10,
                          start_date: '',
                          end_date: '',
                          loadingTime: 0);
                      calendarController.resetDate();
                    },
                  ),
                  estampLogsController.filterEstamp.length > 10
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
                              title: 'search'.tr,
                              searchText: searchText,
                              clear: () {
                                searchText.clear();
                                estampLogsController.logsEstamp.assignAll(
                                    estampLogsController.filterEstamp);
                              },
                              changed: (value) {
                                estampLogsController.searchData(value);
                              },
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
                child: estampLogsController.logsEstamp.isEmpty
                    ? Logo_Opacity(title: 'data_not_found'.tr)
                    : RefreshIndicator(
                        onRefresh: () async {
                          estampLogsController.getEstampLogs(
                              rowItem: estampLogsController.logsEstamp.length,
                              start_date: calendarController.startDate.value,
                              end_date: calendarController.endDate.value,
                              loadingTime: 100);
                        },
                        child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 80),
                            controller: estampLogsController.scrollController,
                            itemCount: estampLogsController.hasMore
                                ? estampLogsController.logsEstamp.length + 1
                                : estampLogsController.logsEstamp.length,
                            itemBuilder: (context, index) {
                              if (index >=
                                  estampLogsController.logsEstamp.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircleLoading(),
                                );
                              }
                              return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  elevation: 10,
                                  child: ListTile(
                                    title: Text(
                                      '${'license_plate'.tr} : ${estampLogsController.logsEstamp[index].plateNum}',
                                      overflow: TextOverflow.ellipsis,
                                      style: Get.textTheme.bodySmall,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${'discount'.tr} : ${estampLogsController.logsEstamp[index].estampName}',
                                        ),
                                        Text(
                                          '${'date'.tr} : ${estampLogsController.logsEstamp[index].createDate}',
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
                      )),
          ],
        ),
      );
    });
  }
}
