// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/models/get_logs_all.dart';
import 'package:doormster/models/get_logs_today.dart';
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
  List<DatalogAll> logsDate = [];
  List<Data> listdata = [];
  List<Data> listlogs = [];
  bool loading = false;
  bool load = false;
  DateFormat formatTime = DateFormat('HH:mm');
  TextEditingController fieldText = TextEditingController();
  DateTime now = DateTime.now();

  Future _getCheckPoint(loadingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');
    print('roundId: ${widget.roundId}');

    try {
      setState(() {
        loading = true;
      });

      await Future.delayed(Duration(milliseconds: loadingTime));

      //call api
      var url =
          '${Connect_api().domain}/get/logToday/$companyId/${widget.roundId}';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getLogsToday logtoday = getLogsToday.fromJson(response.data);
        setState(() {
          listdata = logtoday.data!;
          listlogs = listdata;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(const Duration(milliseconds: 500));
      error_connected(() {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context);
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future _getLogImages(String id) async {
    try {
      setState(() {
        load = true;
      });

      //call api
      var url =
          '${Connect_api().domain}/get/logImages/$id'; // get log show image
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getLogsAll logs = getLogsAll.fromJson(response.data);
        setState(() {
          logsDate = logs.data!;
          showImages(logsDate[0].pic);
          load = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(const Duration(milliseconds: 500));
      error_connected(() {
        Navigator.of(context, rootNavigator: true).pop();
      });
      setState(() {
        load = false;
      });
    }
  }

  void _searchData(String text) {
    setState(() {
      listdata = listlogs.where((item) {
        var name = item.checkpointName!.toLowerCase();
        return name.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    _getCheckPoint(280);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateFormat('dd-MM-y').format(now);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('checkpoint_report'.tr)),
          body: loading
              ? Container()
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2.5, color: Get.theme.primaryColorDark),
                          color: Get.theme.cardTheme.color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textIcon(
                              '${'date_report'.tr} : $dateNow',
                              Icon(
                                Icons.calendar_month_rounded,
                                color: Get.theme.primaryColorDark,
                                size: 25,
                              )),
                          textIcon(
                              '${'round'.tr} : ${widget.roundName}',
                              Icon(
                                Icons.map_rounded,
                                color: Get.theme.primaryColorDark,
                                size: 25,
                              )),
                          textIcon(
                              '${'interval'.tr} : ${widget.roundStart} ${'to'.tr} ${widget.roundEnd}',
                              Icon(
                                Icons.access_time_rounded,
                                color: Get.theme.primaryColorDark,
                                size: 25,
                              )),
                        ],
                      ),
                    ),
                    listlogs.length > 10
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Search_From(
                              title: 'search'.tr,
                              fieldText: fieldText,
                              clear: () {
                                setState(() {
                                  fieldText.clear();
                                  listdata = listlogs;
                                });
                              },
                              changed: (value) {
                                _searchData(value);
                              },
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: listdata.isEmpty
                          ? Logo_Opacity(title: 'no_data'.tr)
                          : RefreshIndicator(
                              onRefresh: () async {
                                _getCheckPoint(500);
                              },
                              child: ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  itemCount: listdata.length,
                                  itemBuilder: (context, index) {
                                    final fileList = listdata[index].logsToday!;
                                    final checklist = listdata[index].checklist;
                                    return fileList.isEmpty
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
                                                    '${'checkpoint'.tr} : ${listdata[index].checkpointName}'),
                                                subtitle: textDoubleColors(
                                                    'status'.tr,
                                                    Theme.of(context)
                                                        .dividerColor,
                                                    'not_checked'.tr,
                                                    Colors.red)),
                                          )
                                        : Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            elevation: 10,
                                            color: Colors.transparent,
                                            child: ExpansionTile(
                                                title: Text(
                                                  '${'checkpoint'.tr} : ${listdata[index].checkpointName}',
                                                  style:
                                                      Get.textTheme.bodyText2,
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${'record_time'.tr} : ${formatTime.format(DateTime.parse(fileList[0].checktimeReal!))}'),
                                                    textDoubleColors(
                                                        'status'.tr,
                                                        Get.textTheme.bodyText2
                                                            ?.color,
                                                        'checked_complete'.tr,
                                                        Theme.of(context)
                                                            .primaryColorDark),
                                                  ],
                                                ),
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      textIcon(
                                                        'event'.tr,
                                                        Icon(
                                                          Icons.edit_document,
                                                          color: Get.theme
                                                              .dividerColor,
                                                          size: 25,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20,
                                                                vertical: 3),
                                                        child: Text(
                                                            '- ${fileList[0].event}'),
                                                      ),
                                                      textIcon(
                                                        'checklist'.tr,
                                                        Icon(
                                                          Icons.task_rounded,
                                                          color: Get.theme
                                                              .dividerColor,
                                                          size: 25,
                                                        ),
                                                      ),
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 3,
                                                                horizontal: 20),
                                                        itemCount:
                                                            checklist?.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return checklist![
                                                                          index]
                                                                      .checklist ==
                                                                  ''
                                                              ? Container()
                                                              : Text(
                                                                  '- ${checklist[index].checklist}');
                                                        },
                                                      ),
                                                      fileList[0].desciption !=
                                                              ''
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                textIcon(
                                                                  'desciption'
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
                                                                    '- ${fileList[0].desciption}',
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
                                                                color: Get.theme
                                                                    .dividerColor,
                                                                size: 25,
                                                              ),
                                                            ),
                                                          ),
                                                          button(
                                                              'view_pictures'
                                                                  .tr,
                                                              Get
                                                                  .textTheme
                                                                  .bodyText1
                                                                  ?.color,
                                                              Theme.of(context)
                                                                  .primaryColorDark,
                                                              Icons.photo, () {
                                                            _getLogImages(
                                                                fileList[0]
                                                                    .sId!);
                                                          })
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
                                                                    .red
                                                                    .shade600,
                                                                size: 25,
                                                              ),
                                                            ),
                                                          ),
                                                          button(
                                                              'view_location'
                                                                  .tr,
                                                              Colors.white,
                                                              Colors
                                                                  .red.shade600,
                                                              Icons.map, () {
                                                            showMap(
                                                                fileList[index]
                                                                    .lat!,
                                                                fileList[index]
                                                                    .lng!);
                                                          })
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
        loading || load ? Loading() : Container()
      ],
    );
  }

  void showImages(listImages) {
    showDialog(
        useRootNavigator: true,
        context: context,
        builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(vertical: 150, horizontal: 20),
              child: listImages.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_rounded,
                              size: 50,
                            ),
                            Text('ไม่มีรูปภาพ')
                          ]),
                    )
                  : Swiper(
                      loop: false,
                      pagination: const SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                              size: 8,
                              activeSize: 8,
                              color: Colors.grey,
                              activeColor: Colors.white)),
                      control: const SwiperControl(
                          color: Colors.white,
                          iconPrevious: Icons.arrow_back_ios_new_rounded,
                          iconNext: Icons.arrow_forward_ios_rounded),
                      itemCount: listImages.length,
                      itemBuilder: (context, index) {
                        var _Images = convert.base64Decode(
                            ('${listImages[index]}').split(',').last);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _Images,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ));
  }

  void showMap(lat, lng) {
    showDialog(
        useRootNavigator: true,
        context: context,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding:
                  const EdgeInsets.symmetric(vertical: 180, horizontal: 28),
              child: Map_Page(
                width: double.infinity,
                height: double.infinity,
                lat: lat,
                lng: lng,
              ),
            ));
  }

  Widget button(name, textColor, color, icon, press) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        primary: textColor,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 3),
          Text(
            name,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      onPressed: press,
    );
  }
}
