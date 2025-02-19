import 'package:doormster/controller/calendar_controller.dart';
import 'package:doormster/utils/date_time_utils.dart';
import 'package:doormster/widgets/button/button_text_icon.dart';
import 'package:doormster/widgets/calendar/calendar.dart';
import 'package:doormster/widgets/dottedLine/dotted_line.dart';
import 'package:doormster/widgets/image/dialog_images.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/searchbar/search_calendar.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/controller/complaint_controller.dart';
import 'package:doormster/screen/qr_smart_access/add_complaint_page.dart';
import 'package:doormster/screen/qr_smart_access/edit_complaint_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Complaint_Page extends StatefulWidget {
  const Complaint_Page({super.key});

  @override
  State<Complaint_Page> createState() => _Complaint_PageState();
}

class _Complaint_PageState extends State<Complaint_Page> {
  final ComplaintController complaintController =
      Get.put(ComplaintController());
  final CalendarController calendarController = Get.put(CalendarController());
  TextEditingController searchText = TextEditingController();

  ScrollController scrollController = ScrollController();
  int count = 10;
  bool _hasMore = false;

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
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Obx(() => Scaffold(
            appBar: AppBar(title: Text('complaint_list'.tr)),
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
                              await complaintController.get_ComplaintAll(
                                  start_date:
                                      calendarController.startDate.value,
                                  end_date: calendarController.endDate.value,
                                  loadingTime: 100);
                            }
                          });
                        },
                        onClear: () async {
                          await complaintController.get_ComplaintAll(
                              start_date: '', end_date: '', loadingTime: 0);
                          calendarController.resetDate();
                        },
                      ),
                      complaintController.filterComplaint.length > 10
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                    complaintController.listComplaint.assignAll(
                                        complaintController.filterComplaint);
                                  },
                                  changed: (value) {
                                    complaintController.searchData(value);
                                  },
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
                Expanded(
                    child: complaintController.listComplaint.isEmpty
                        ? Logo_Opacity(title: 'data_not_found'.tr)
                        : RefreshIndicator(
                            onRefresh: () async {
                              complaintController.get_ComplaintAll(
                                  start_date:
                                      calendarController.startDate.value,
                                  end_date: calendarController.endDate.value,
                                  loadingTime: 100);
                            },
                            child: ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 80),
                                controller: scrollController,
                                itemCount: count <
                                        complaintController.listComplaint.length
                                    ? count + (_hasMore ? 1 : 0)
                                    : complaintController.listComplaint.length,
                                itemBuilder: (context, index) {
                                  if (index >= count) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: CircleLoading(),
                                    );
                                  }
                                  final date = DateTimeUtils.format(
                                    complaintController
                                        .listComplaint[index].createDate!,
                                    'D',
                                  );
                                  final time = DateTimeUtils.format(
                                    complaintController
                                        .listComplaint[index].createDate!,
                                    'T',
                                  );
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      elevation: 10,
                                      child: ExpansionTile(
                                          title: Text(
                                            '${'title'.tr} : ${complaintController.listComplaint[index].docName}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${'date'.tr} $date ${'time'.tr} $time',
                                              ),
                                              Text(
                                                '${'status'.tr} : ${"${complaintController.listComplaint[index].statusId}cp".tr}'
                                                    .tr,
                                              ),
                                            ],
                                          ),
                                          expandedCrossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                textIcon(
                                                    'description'.tr,
                                                    Icon(
                                                      Icons.description_rounded,
                                                      size: 25,
                                                      color: Get
                                                          .theme.dividerColor,
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 3),
                                                    child: complaintController
                                                                .listComplaint[
                                                                    index]
                                                                .description !=
                                                            ''
                                                        ? Text(
                                                            '- ${complaintController.listComplaint[index].description}',
                                                          )
                                                        : const Text('-')),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                    child: textIcon(
                                                        'pictures'.tr,
                                                        Icon(
                                                          Icons
                                                              .photo_library_rounded,
                                                          size: 25,
                                                          color:
                                                              Theme.of(context)
                                                                  .dividerColor,
                                                        ))),
                                                Buttons_textIcon(
                                                    title: 'view_pictures'.tr,
                                                    icon: Icons.photo,
                                                    press: () {
                                                      showImages_Dialog(
                                                          context: context,
                                                          listImages:
                                                              complaintController
                                                                  .listComplaint[
                                                                      index]
                                                                  .complaintImg);
                                                    })
                                              ],
                                            ),
                                            complaintController
                                                        .listComplaint[index]
                                                        .statusId !=
                                                    1
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Buttons_textIcon(
                                                          title: 'edit'.tr,
                                                          icon: Icons
                                                              .mode_edit_outlined,
                                                          press: () {
                                                            Get.to(
                                                              () =>
                                                                  Edit_Complaint(
                                                                complaint_data:
                                                                    complaintController
                                                                            .listComplaint[
                                                                        index],
                                                              ),
                                                            );
                                                          }),
                                                      Buttons_textIcon(
                                                          title: 'cancel'.tr,
                                                          textColor:
                                                              Colors.white,
                                                          buttonColor: Colors
                                                              .red.shade600,
                                                          icon: Icons
                                                              .delete_forever_rounded,
                                                          press: () {
                                                            complaintController.updateStatus_Complaint(
                                                                doc_id: complaintController
                                                                    .listComplaint[
                                                                        index]
                                                                    .docId,
                                                                status: 6,
                                                                succress:
                                                                    'cancel_success',
                                                                fail:
                                                                    'cancel_unsuccess');
                                                          }),
                                                    ],
                                                  ),
                                            complaintController
                                                        .listComplaint[index]
                                                        .statusId !=
                                                    5
                                                ? Container()
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'resolved'.tr,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        child: Buttons_textIcon(
                                                            title: 'close'.tr,
                                                            textColor:
                                                                Colors.white,
                                                            buttonColor:
                                                                Colors.green,
                                                            icon: Icons
                                                                .check_circle,
                                                            press: () {
                                                              complaintController.updateStatus_Complaint(
                                                                  doc_id: complaintController
                                                                      .listComplaint[
                                                                          index]
                                                                      .docId,
                                                                  status: 5,
                                                                  succress:
                                                                      'close_success'
                                                                          .tr,
                                                                  fail:
                                                                      'close_unsuccess');
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                          ]));
                                }),
                          )),
              ],
            ),
            floatingActionButton: connectApi.loading.isTrue
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      Get.to(() => const Add_Complaint());
                    },
                    child: const Icon(Icons.add),
                  ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          )),
    );
  }
}
