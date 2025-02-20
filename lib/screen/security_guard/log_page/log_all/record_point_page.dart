// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last, unrelated_type_equality_checks, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/controller/security_controller/logs_all_controller.dart';
import 'package:doormster/utils/date_time_utils.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/button/button_text_icon.dart';
import 'package:doormster/widgets/image/dialog_images.dart';
import 'package:doormster/widgets/list_null_opacity/logo_opacity.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/widgets/map/map_dialog.dart';
import 'package:doormster/widgets/map/map_page.dart';
import 'package:doormster/widgets/searchbar/search_from.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/widgets/text/text_icon.dart';
import 'package:doormster/controller/security_controller/logs_today_controller.dart';
import 'package:doormster/models/secarity_models/get_log_all.dart';
import 'package:doormster/models/secarity_models/get_logs_img.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

class Record_Point extends StatefulWidget {
  final logs;
  final roundName;
  final roundStart;
  final roundEnd;
  final dateTime;
  const Record_Point(
      {super.key,
      this.logs,
      this.roundName,
      this.roundStart,
      this.roundEnd,
      this.dateTime});

  @override
  State<Record_Point> createState() => _Record_PointState();
}

class _Record_PointState extends State<Record_Point> {
  final LogsTodayController logsController = Get.put(LogsTodayController());
  List<Logs> listlogs1 = [];
  List<Logs> listlogs2 = [];
  TextEditingController fieldText = TextEditingController();
  ScrollController scrollController = ScrollController();
  int count = 10;
  bool _hasMore = false;

  void _searchData(String text) {
    setState(() {
      listlogs1 = listlogs2.where((item) {
        String name = item.locationName!;
        String dateLogs = item.createDate!;
        String event = item.event!.tr;
        return name.contains(text) ||
            dateLogs.contains(text) ||
            event.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
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
    listlogs1 = widget.logs;
    listlogs2 = listlogs1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('checkpoint_report'.tr)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(
                    width: 2.5, color: Theme.of(context).primaryColorDark),
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textIcon(
                    '${'date_report'.tr} : ${widget.dateTime}',
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Theme.of(context).primaryColorDark,
                      size: 25,
                    )),
                textIcon(
                    '${'round'.tr} : ${widget.roundName}',
                    Icon(
                      Icons.map_rounded,
                      color: Theme.of(context).primaryColorDark,
                      size: 25,
                    )),
                widget.roundName == 'extra_round'.tr
                    ? Container()
                    : textIcon(
                        '${'interval'.tr} : ${widget.roundStart} ${'to'.tr} ${widget.roundEnd}',
                        Icon(
                          Icons.access_time_rounded,
                          color: Theme.of(context).primaryColorDark,
                          size: 25,
                        ))
              ],
            ),
          ),
          listlogs2.length > 10
              ? Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Search_From(
                    title: 'search'.tr,
                    searchText: fieldText,
                    clear: () {
                      setState(() {
                        fieldText.clear();
                        listlogs1 = listlogs2;
                      });
                    },
                    changed: (value) {
                      _searchData(value);
                    },
                  ),
                )
              : Container(),
          Expanded(
            child: listlogs1.isEmpty
                ? Logo_Opacity(title: 'no_data'.tr)
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                    controller: scrollController,
                    itemCount: count < listlogs1.length
                        ? count + (_hasMore ? 1 : 0)
                        : listlogs1.length,
                    itemBuilder: (context, index) {
                      if (index >= count) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircleLoading(),
                        );
                      }
                      final date = DateTimeUtils.format(
                          listlogs1[index].createDate!, 'D');
                      final time = DateTimeUtils.format(
                          listlogs1[index].createDate!, 'T');

                      final listcheck = listlogs1[index].checkpointList;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        elevation: 10,
                        color: Colors.transparent,
                        child: ExpansionTile(
                            title: Text(
                              '${'checkpoint'.tr} : ${listlogs1[index].locationName}',
                              style: Get.textTheme.bodySmall,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${'event'.tr} : ${"${listlogs1[index].event}".tr}'
                                      .tr,
                                ),
                                Text(
                                  '${'date'.tr} $date ${'time'.tr} $time',
                                ),
                              ],
                            ),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textIcon(
                                      'checklist'.tr,
                                      color: Theme.of(context).dividerColor,
                                      Icon(
                                        Icons.task_rounded,
                                        size: 25,
                                        color: Theme.of(context).dividerColor,
                                      )),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    reverse: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 20),
                                    itemCount: listcheck?.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return listcheck?[index].checkpointName ==
                                                  null ||
                                              listcheck!.isEmpty
                                          ? const Text('-')
                                          : Text(
                                              '- ${listcheck[index].checkpointName}',
                                            );
                                    },
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          child:
                                              listlogs1[index].description != ''
                                                  ? Text(
                                                      '- ${listlogs1[index].description}',
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
                                                Icons.photo_library_rounded,
                                                size: 25,
                                                color: Theme.of(context)
                                                    .dividerColor,
                                              ))),
                                      Buttons_textIcon(
                                          title: 'view_pictures'.tr,
                                          icon: Icons.photo,
                                          press: () async {
                                            final List<Img> listImg =
                                                await logsController
                                                    .get_logImages(
                                                        log_Id: listlogs1[index]
                                                            .guardLogId!);
                                            showImages_Dialog(
                                                context: context,
                                                listImages: listImg.length == 1
                                                    ? listImg[0].imgPath
                                                    : listImg);
                                          }),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: textIcon(
                                        'checkpoint_location'.tr,
                                        Icon(
                                          Icons.location_on_sharp,
                                          size: 25,
                                          color: Colors.red.shade600,
                                        ),
                                      )),
                                      Buttons_textIcon(
                                          title: 'view_location'.tr,
                                          icon: Icons.map,
                                          textColor: Colors.white,
                                          buttonColor: Colors.red.shade600,
                                          press: () {
                                            showMap_Dialog(
                                              context: context,
                                              vertical: 180,
                                              horizontal: 30,
                                              lat: double.parse(
                                                  listlogs2[index].lat!),
                                              lng: double.parse(
                                                  listlogs2[index].lng!),
                                            );
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
