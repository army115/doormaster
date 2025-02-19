import 'package:doormster/controller/calendar_controller.dart';
import 'package:doormster/utils/date_time_utils.dart';
import 'package:doormster/widgets/button/button_text_icon.dart';
import 'package:doormster/widgets/calendar/calendar.dart';
import 'package:doormster/widgets/image/dialog_images.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/searchbar/search_calendar.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/controller/sos_controller.dart';
import 'package:doormster/screen/qr_smart_access/add_sos_page.dart';
import 'package:doormster/screen/qr_smart_access/edit_sos_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:doormster/widgets/dottedLine/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SOS_Page extends StatefulWidget {
  const SOS_Page({super.key});

  @override
  State<SOS_Page> createState() => _SOS_PageState();
}

class _SOS_PageState extends State<SOS_Page> {
  final SOSController sosController = Get.put(SOSController());
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
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: const Text('SOS')),
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
                            await sosController.get_SOS(
                                start_date: calendarController.startDate.value,
                                end_date: calendarController.endDate.value,
                                loadingTime: 100);
                          }
                        },
                      );
                    },
                    onClear: () async {
                      await sosController.get_SOS(
                          start_date: '', end_date: '', loadingTime: 0);
                      calendarController.resetDate();
                    },
                  ),
                  sosController.filterSOS.length > 10
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
                                sosController.listSOS
                                    .assignAll(sosController.filterSOS);
                              },
                              changed: (value) {
                                sosController.searchData(value);
                              },
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
            Expanded(
                child: sosController.listSOS.isEmpty
                    ? Logo_Opacity(title: 'data_not_found'.tr)
                    : RefreshIndicator(
                        onRefresh: () async {
                          sosController.get_SOS(
                              start_date: calendarController.startDate.value,
                              end_date: calendarController.endDate.value,
                              loadingTime: 100);
                        },
                        child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 80),
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: count < sosController.listSOS.length
                                ? count + (_hasMore ? 1 : 0)
                                : sosController.listSOS.length,
                            itemBuilder: ((context, index) {
                              if (index >= count) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: CircleLoading(),
                                );
                              }
                              final date = DateTimeUtils.format(
                                sosController.listSOS[index].createDate!,
                                'D',
                              );
                              final time = DateTimeUtils.format(
                                sosController.listSOS[index].createDate!,
                                'T',
                              );

                              return sosController.listSOS[index].statusId == 4
                                  ? Container()
                                  : Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      elevation: 10,
                                      child: ExpansionTile(
                                          title: Text(
                                            '${'title'.tr} : ${sosController.listSOS[index].docName}',
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
                                                '${'status'.tr} : ${"${sosController.listSOS[index].status}".tr}'
                                                    .tr,
                                              ),
                                            ],
                                          ),
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    textIcon(
                                                        'description'.tr,
                                                        Icon(
                                                          Icons
                                                              .description_rounded,
                                                          size: 25,
                                                          color: Get.theme
                                                              .dividerColor,
                                                        )),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 3),
                                                        child: sosController
                                                                    .listSOS[
                                                                        index]
                                                                    .description !=
                                                                ''
                                                            ? Text(
                                                                '- ${sosController.listSOS[index].description}',
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
                                                              color: Theme.of(
                                                                      context)
                                                                  .dividerColor,
                                                            ))),
                                                    Buttons_textIcon(
                                                        title:
                                                            'view_pictures'.tr,
                                                        icon: Icons.photo,
                                                        press: () {
                                                          showImages_Dialog(
                                                              context: context,
                                                              listImages:
                                                                  sosController
                                                                      .listSOS[
                                                                          index]
                                                                      .imgPath);
                                                        }),
                                                  ],
                                                ),
                                                sosController.listSOS[index]
                                                                .statusId !=
                                                            1 &&
                                                        sosController
                                                                .listSOS[index]
                                                                .statusId !=
                                                            2
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
                                                                Get.to(() => Edit_SOS(
                                                                    sos_data: sosController
                                                                            .listSOS[
                                                                        index]));
                                                              }),
                                                          Buttons_textIcon(
                                                              title:
                                                                  'delete'.tr,
                                                              textColor:
                                                                  Colors.white,
                                                              buttonColor:
                                                                  Colors.red
                                                                      .shade600,
                                                              icon: Icons
                                                                  .delete_forever_rounded,
                                                              press: () {
                                                                sosController.updateStatus_SOS(
                                                                    doc_id: sosController
                                                                        .listSOS[
                                                                            index]
                                                                        .docId);
                                                              }),
                                                        ],
                                                      )
                                              ],
                                            )
                                          ]));
                            })),
                      )),
          ],
        ),
        floatingActionButton: connectApi.loading.isTrue
            ? Container()
            : FloatingActionButton(
                onPressed: () {
                  permissionLocation(
                      context, () => Get.to(() => const Add_SOS()));
                },
                child: const Icon(Icons.add),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
