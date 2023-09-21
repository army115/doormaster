// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last, unrelated_type_equality_checks

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/models/get_logs_all.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class Record_Point extends StatefulWidget {
  final fileList;
  final roundName;
  final roundStart;
  final roundEnd;
  final dateTime;
  Record_Point(
      {Key? key,
      this.fileList,
      this.roundName,
      this.roundStart,
      this.roundEnd,
      this.dateTime})
      : super(key: key);

  @override
  State<Record_Point> createState() => _Record_PointState();
}

class _Record_PointState extends State<Record_Point> {
  List<DatalogAll> logsDate = [];
  List<FileList> fileList = [];
  List<FileList> logsList = [];
  bool loading = false;
  DateFormat formatTime = DateFormat('HH:mm');
  DateFormat formatdate = DateFormat('dd-MM-y');
  TextEditingController fieldText = TextEditingController();
  // DateTime? time;
  // DateTime? date;

  Future _getLog(String id) async {
    try {
      setState(() {
        loading = true;
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
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(const Duration(milliseconds: 500));
      error_connected(context, () {
        Navigator.of(context, rootNavigator: true).pop();
      });
      setState(() {
        loading = false;
      });
    }
  }

  void _searchData(String text) {
    setState(() {
      fileList = logsList.where((item) {
        String name = item.checkpointName!.toLowerCase();
        String dates = formatdate.format(DateTime.parse(item.date!));
        String times = formatTime.format(DateTime.parse(item.checktimeReal!));
        String event = item.event!.toLowerCase();
        return name.contains(text) ||
            dates.contains(text) ||
            times.contains(text) ||
            event.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    fileList = widget.fileList;
    logsList = fileList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('checkpoint_report'.tr)),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2.5, color: Theme.of(context).primaryColor),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textIcon(
                        '${'date_report'.tr} : ${widget.dateTime}',
                        Icon(
                          Icons.calendar_month_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        )),
                    textIcon(
                        '${'round'.tr} : ${widget.roundName}',
                        Icon(
                          Icons.map_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 25,
                        )),
                    widget.roundName == 'extra_round'.tr
                        ? Container()
                        : textIcon(
                            '${'interval'.tr} : ${widget.roundStart} ${'to'.tr} ${widget.roundEnd}',
                            Icon(
                              Icons.access_time_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 25,
                            ))
                  ],
                ),
              ),
              logsList.length > 10
                  ? Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: Search_From(
                        title: 'search'.tr,
                        fieldText: fieldText,
                        clear: () {
                          setState(() {
                            fieldText.clear();
                            fileList = logsList;
                          });
                        },
                        changed: (value) {
                          _searchData(value);
                        },
                      ),
                    )
                  : Container(),
              Expanded(
                child: fileList.isEmpty
                    ? Logo_Opacity(title: 'no_data'.tr)
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        itemCount: fileList.length,
                        itemBuilder: (context, index) {
                          final time = DateTime.parse(
                              '${fileList[index].checktimeReal}');
                          final listcheck = fileList[index].checklist;
                          final date =
                              DateTime.parse('${fileList[index].date}');

                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            elevation: 10,
                            child: ExpansionTile(
                                textColor: Colors.black,
                                title: Text(
                                    '${'checkpoint'.tr} : ${fileList[index].checkpointName}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${'event'.tr} : ${fileList[index].event}'),
                                    Text(
                                        '${'date'.tr} ${formatdate.format(date)} ${'time'.tr} ${formatTime.format(time)}'),
                                  ],
                                ),
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(
                                                10)), // Set the border radius here
                                        color: Colors.grey.shade200),
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textIcon(
                                            'checklist'.tr,
                                            const Icon(
                                              Icons.task_rounded,
                                              size: 25,
                                              color: Colors.black,
                                            )),
                                        ListView.builder(
                                          shrinkWrap: true,
                                          primary: false,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 20),
                                          itemCount: listcheck?.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return listcheck?[index] == ''
                                                ? Container()
                                                : Text(
                                                    '- ${listcheck?[index]}');
                                          },
                                        ),
                                        fileList[index].desciption != ''
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  textIcon(
                                                      'desciption'.tr,
                                                      const Icon(
                                                        Icons
                                                            .description_rounded,
                                                        size: 25,
                                                        color: Colors.black,
                                                      )),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 3),
                                                    child: Text(
                                                      '- ${fileList[index].desciption}',
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
                                                    const Icon(
                                                      Icons
                                                          .photo_library_rounded,
                                                      size: 25,
                                                      color: Colors.black,
                                                    ))),
                                            button(
                                                'view_pictures'.tr,
                                                Theme.of(context).primaryColor,
                                                Icons.photo, () {
                                              _getLog(fileList[index].sId!);
                                            })
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
                                            button(
                                                'view_location'.tr,
                                                Colors.red.shade600,
                                                Icons.map, () {
                                              showMap(fileList[index].lat!,
                                                  fileList[index].lng!);
                                            })
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          );
                        }),
              ),
            ],
          ),
        ),
        loading ? Loading() : Container()
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
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported_rounded,
                              size: 50,
                            ),
                            Text('no_picture'.tr)
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
                  const EdgeInsets.symmetric(vertical: 180, horizontal: 30),
              child: Map_Page(
                width: double.infinity,
                height: double.infinity,
                lat: lat,
                lng: lng,
              ),
            ));
  }

  Widget button(name, color, icon, press) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
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
