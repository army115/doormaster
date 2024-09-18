// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last

import 'dart:developer';
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button_text_icon.dart';
import 'package:doormster/components/image/dialog_images.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_dialog.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/controller/security_controller/logs_controller.dart';
import 'package:doormster/models/secarity_models/get_logs_img.dart';
import 'package:doormster/models/secarity_models/get_logs_round.dart';

import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class Logs_Point extends StatefulWidget {
  final roundId;
  final roundName;
  final roundStart;
  final roundEnd;
  const Logs_Point(
      {Key? key, this.roundName, this.roundStart, this.roundEnd, this.roundId})
      : super(key: key);

  @override
  State<Logs_Point> createState() => _Logs_PointState();
}

class _Logs_PointState extends State<Logs_Point> {
  List<logRound> listlogs1 = logsController.listLog_Round;
  List<logRound> listlogs2 = logsController.listLog_Round;
  TextEditingController fieldText = TextEditingController();
  DateTime now = DateTime.now();

  void _searchData(String text) {
    setState(() {
      listlogs1 = listlogs2.where((item) {
        var name = item.locationName!;
        return name.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await logsController.get_logRound(
          loadingTime: 100, inspectId: widget.roundId);
    });
    super.initState();
  }

  String createformat(String fullTime) {
    DateFormat formatTime = DateFormat('HH:mm');
    return formatTime.format(DateTime.parse(fullTime));
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateFormat('dd-MM-y').format(now);
    return Obx(
      () => Scaffold(
        appBar: AppBar(title: Text('checkpoint_report'.tr)),
        body: connectApi.loading.isTrue
            ? Loading()
            : Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2.5,
                            color: Theme.of(context).primaryColorDark),
                        color: Theme.of(context).cardTheme.color,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textIcon(
                            '${'date_report'.tr} : $dateNow',
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
                        textIcon(
                            '${'interval'.tr} : ${widget.roundStart} ${'to'.tr} ${widget.roundEnd}',
                            Icon(
                              Icons.access_time_rounded,
                              color: Theme.of(context).primaryColorDark,
                              size: 25,
                            )),
                      ],
                    ),
                  ),
                  listlogs2.length > 10
                      ? Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
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
                        : RefreshIndicator(
                            onRefresh: () async {
                              logsController.get_logRound(
                                  loadingTime: 100, inspectId: widget.roundId);
                            },
                            child: ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                itemCount: listlogs1.length,
                                itemBuilder: (context1, index) {
                                  final logsList = listlogs1[index].logs!;
                                  final checklist =
                                      listlogs1[index].checkpointList;
                                  return logsList.isEmpty
                                      ? Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          elevation: 10,
                                          child: ListTile(
                                              textColor: Theme.of(context)
                                                  .dividerColor,
                                              title: Text(
                                                '${'checkpoint'.tr} : ${listlogs1[index].locationName}',
                                                style: Get.textTheme.bodySmall,
                                              ),
                                              subtitle: textDoubleColors(
                                                  "${'status'.tr} : ",
                                                  Theme.of(context)
                                                      .dividerColor,
                                                  listlogs1[index].verify == 0
                                                      ? "no_regis".tr
                                                      : 'not_checked'.tr,
                                                  listlogs1[index].verify == 0
                                                      ? Colors.orange
                                                      : Colors.red)),
                                        )
                                      : Card(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          elevation: 10,
                                          color: Colors.transparent,
                                          child: ExpansionTile(
                                              title: Text(
                                                '${'checkpoint'.tr} : ${listlogs1[index].locationName}',
                                                style: Get.textTheme.bodySmall,
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${'record_time'.tr} : ${createformat(logsList[0].createDate!)}'),
                                                  textDoubleColors(
                                                      "${'status'.tr} : ",
                                                      Get.textTheme.bodySmall
                                                          ?.color,
                                                      'checked_complete'.tr,
                                                      Theme.of(context)
                                                          .primaryColorDark),
                                                ],
                                              ),
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    textIcon(
                                                      'event'.tr,
                                                      Icon(
                                                        Icons.edit_document,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                        size: 25,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 3),
                                                      child: Text(
                                                          '- ${"${logsList[index].event}".tr}'),
                                                    ),
                                                    textIcon(
                                                      'checklist'.tr,
                                                      Icon(
                                                        Icons.task_rounded,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                        size: 25,
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      primary: false,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 3,
                                                          horizontal: 20),
                                                      itemCount:
                                                          checklist?.length,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return checklist![index]
                                                                    .checkpointName ==
                                                                ''
                                                            ? Container()
                                                            : Text(
                                                                '- ${checklist[index].checkpointName}');
                                                      },
                                                    ),
                                                    logsList[0].description !=
                                                            ''
                                                        ? Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              textIcon(
                                                                'description'
                                                                    .tr,
                                                                Icon(
                                                                  Icons
                                                                      .description_rounded,
                                                                  color: Get
                                                                      .theme
                                                                      .dividerColor,
                                                                  size: 25,
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        20,
                                                                    vertical:
                                                                        3),
                                                                child: Text(
                                                                  '- ${logsList[0].description}',
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: textIcon(
                                                            'pictures'.tr,
                                                            Icon(
                                                              Icons
                                                                  .photo_library_rounded,
                                                              color: Theme.of(
                                                                      context)
                                                                  .dividerColor,
                                                              size: 25,
                                                            ),
                                                          ),
                                                        ),
                                                        Buttons_textIcon(
                                                            title:
                                                                'view_pictures'
                                                                    .tr,
                                                            icon: Icons.photo,
                                                            press: () async {
                                                              final List<Img>
                                                                  listImg =
                                                                  await logsController.get_logImages(
                                                                      log_Id: logsList
                                                                          .last
                                                                          .guardLogId);
                                                              showImages_Dialog(
                                                                  context:
                                                                      context,
                                                                  listImages: listImg
                                                                              .length ==
                                                                          1
                                                                      ? listImg[
                                                                              0]
                                                                          .imgPath
                                                                      : listImg);
                                                            }),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: textIcon(
                                                            'checkpoint_location'
                                                                .tr,
                                                            Icon(
                                                              Icons
                                                                  .location_on_sharp,
                                                              color: Colors
                                                                  .red.shade600,
                                                              size: 25,
                                                            ),
                                                          ),
                                                        ),
                                                        Buttons_textIcon(
                                                            title:
                                                                'view_location'
                                                                    .tr,
                                                            textColor:
                                                                Colors.white,
                                                            buttonColor: Colors
                                                                .red.shade600,
                                                            icon: Icons.map,
                                                            press: () {
                                                              showMap_Dialog(
                                                                context:
                                                                    context,
                                                                vertical: 180,
                                                                horizontal: 28,
                                                                lat: double.parse(
                                                                    logsList[
                                                                            index]
                                                                        .lat!),
                                                                lng: double.parse(
                                                                    logsList[
                                                                            index]
                                                                        .lng!),
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                        );
                                }),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
