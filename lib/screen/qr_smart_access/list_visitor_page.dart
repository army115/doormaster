import 'package:doormster/controller/calendar_controller.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/searchbar/search_calendar.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListVisitor extends StatefulWidget {
  const ListVisitor({super.key});

  @override
  State<ListVisitor> createState() => _ListVisitorState();
}

class _ListVisitorState extends State<ListVisitor> {
  final CalendarController calendarController = Get.put(CalendarController());
  TextEditingController fieldText = TextEditingController();
  TextEditingController searchText = TextEditingController();
  List listsVisitor = ['teds', 'yt4r'];
  int count = 10;
  bool _hasMore = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('list_visitor'.tr),
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
                    // await CalendarPicker_2Date(
                    //         context: context, listDate: listDate)
                    //     .then(
                    //   (value) async {
                    //     if (value != null) {
                    //       setState(() {
                    //         startDate = value['startDate'];
                    //         endDate = value['endDate'];
                    //         fieldText.text = value['showDate'];
                    //         listDate = value['listDate'];
                    //       });
                    //       await complaintController.get_ComplaintAll(
                    //           start_date: startDate,
                    //           end_date: endDate,
                    //           loadingTime: 100);
                    //     }
                    //   },
                    // );
                  },
                  onClear: () async {
                    // fieldText.clear();
                    // await complaintController.get_ComplaintAll(
                    //     start_date: '', end_date: '', loadingTime: 0);
                    // setState(() {
                    //   startDate = '';
                    //   endDate = '';
                    //   listDate = [DateTime.now()];
                    // });
                  },
                ),
                // complaintController.filterComplaint.length > 1
                //     ? Column(
                //         children: [
                //           Container(
                //             padding: const EdgeInsets.symmetric(horizontal: 10),
                //             child: DottedLine(
                //               direction: Axis.horizontal,
                //               alignment: WrapAlignment.center,
                //               lineLength: double.infinity,
                //               lineThickness: 2,
                //               dashColor: Colors.grey.shade600,
                //               dashGapColor: Colors.white,
                //             ),
                //           ),
                //           Search_From(
                //             title: 'search'.tr,
                //             searchText: searchText,
                //             clear: () {
                //               searchText.clear();
                //               listsVisitor.assignAll(
                //                   complaintController.filterComplaint);
                //             },
                //             changed: (value) {
                //               complaintController.searchData(value);
                //             },
                //           ),
                //         ],
                //       )
                //     : Container(),
              ],
            ),
          ),
          Expanded(
              child: listsVisitor.isEmpty
                  ? Logo_Opacity(title: 'data_not_found'.tr)
                  : RefreshIndicator(
                      onRefresh: () async {},
                      child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 80),
                          // controller: scrollController,
                          itemCount: count < listsVisitor.length
                              ? count + (_hasMore ? 1 : 0)
                              : listsVisitor.length,
                          itemBuilder: (context, index) {
                            if (index >= count) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: CircleLoading(),
                              );
                            }
                            return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                elevation: 10,
                                child: ExpansionTile(
                                    title: Text(
                                      '${'title'.tr} : ${listsVisitor[index]}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${'date'.tr} : ${"${listsVisitor[index]}cp".tr}'
                                              .tr,
                                        ),
                                        Text(
                                          '${'status'.tr} : ${"${listsVisitor[index]}cp".tr}'
                                              .tr,
                                        ),
                                      ],
                                    ),
                                    expandedCrossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    expandedAlignment: Alignment.centerLeft,
                                    tilePadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    childrenPadding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    children: [
                                      textIcon(
                                          'description'.tr,
                                          Icon(
                                            Icons.description_rounded,
                                            size: 25,
                                            color: Get.theme.dividerColor,
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 3),
                                          child: listsVisitor[index] != ''
                                              ? Text(
                                                  '- ${listsVisitor[index]}',
                                                )
                                              : const Text('-')),
                                    ]));
                          }),
                    )),
        ],
      ),
    );
  }
}
