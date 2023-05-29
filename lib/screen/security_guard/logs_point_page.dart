// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/models/get_logs_all.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class Logs_Point extends StatefulWidget {
  final fileList;
  final roundName;
  final roundStart;
  final roundEnd;
  const Logs_Point(
      {Key? key, this.fileList, this.roundName, this.roundStart, this.roundEnd})
      : super(key: key);

  @override
  State<Logs_Point> createState() => _Logs_PointState();
}

class _Logs_PointState extends State<Logs_Point> {
  List<DatalogAll> logsDate = [];
  List<FileList> fileList = [];
  List<FileList> logsList = [];
  List<Checkpoint> checkpoint = [];
  List<Data> listdata = [];
  bool loading = false;
  DateFormat formatTime = DateFormat('HH:mm');
  TextEditingController fieldText = TextEditingController();
  DateTime? time;
  DateTime now = DateTime.now();

  Future _getCheckPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');

    try {
      setState(() {
        loading = true;
      });

      //call api
      var url = '${Connect_api().domain}/get/checkpoint/${companyId}';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getChecklist checklist = getChecklist.fromJson(response.data);
        setState(() {
          listdata = checklist.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(Duration(milliseconds: 500));
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        homeKey.currentState?.popUntil(ModalRoute.withName('/security'));
        Navigator.of(context, rootNavigator: true).pop();
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  Future _getLogImages(String id) async {
    try {
      setState(() {
        loading = true;
      });

      //call api
      var url = '${Connect_api().domain}/get/logOne/$id'; // get log show image
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
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.of(context, rootNavigator: true).pop();
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  void _searchData(String text) {
    setState(() {
      fileList = logsList.where((item) {
        var name = item.checkpoint![0].checkpointName!.toLowerCase();
        var date = item.date!.toLowerCase();
        var times = formatTime.format(time!);
        var event = item.event!.toLowerCase();
        return name.contains(text) ||
            date.contains(text) ||
            times.contains(text) ||
            event.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    _getCheckPoint();
    fileList = widget.fileList;
    logsList = fileList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateNow = DateFormat('dd-MM-y').format(now);
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(title: const Text('บันทึกจุดตรวจ')),
            body: SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.5,
                                color: Theme.of(context).primaryColor),
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Text('รายงานวันที่ : $dateNow'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.map_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Text('รอบเดิน : ${widget.roundName}'),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                      'ช่วงเวลา : ${widget.roundStart}น. ถึง ${widget.roundEnd}น.'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: listdata.isEmpty
                          ? Logo_Opacity(title: 'ไม่มีข้อมูลที่บันทึก')
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: listdata.length,
                              itemBuilder: (context, index) {
                                // time = DateTime.parse(
                                //     '${fileList[index].checktimeReal}');
                                // checkpoint = fileList[index].checkpoint!;
                                // final checklist = checkpoint[0].checklist;
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  elevation: 10,
                                  child: ExpansionTile(
                                      textColor: Colors.black,
                                      title: Text(
                                        'จุดตรวจ :  ${listdata[index].checkpointName}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        'สถานะ :  ยังไม่ตรวจ',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      // Column(
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.start,
                                      //   children: [
                                      //     Text(
                                      //         'เหตุการณ์ : ${fileList[index].event}'),
                                      //     Text(
                                      //         'วันที่ ${fileList[index].date} เวลา ${formatTime.format(time!)}'),
                                      //   ],
                                      // ),
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius
                                                      .only(
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  bottomRight: Radius.circular(
                                                      10)), // Set the border radius here
                                              color: Colors.grey.shade200),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Row(
                                                children: [
                                                  Icon(Icons.edit_document,
                                                      size: 25),
                                                  SizedBox(width: 5),
                                                  Text('เหตุการณ์'),
                                                ],
                                              ),
                                              const Row(
                                                children: [
                                                  Icon(Icons.task_rounded,
                                                      size: 25),
                                                  SizedBox(width: 5),
                                                  Text('รายการตรวจ'),
                                                ],
                                              ),
                                              // ListView.builder(
                                              //   shrinkWrap: true,
                                              //   primary: false,
                                              //   padding:
                                              //       const EdgeInsets.symmetric(
                                              //           vertical: 5,
                                              //           horizontal: 20),
                                              //   itemCount: checklist!.length,
                                              //   itemBuilder:
                                              //       (BuildContext context,
                                              //           int index) {
                                              //     return checklist[index]
                                              //                 .checklist ==
                                              //             ''
                                              //         ? Container()
                                              //         : Text(
                                              //             '- ${checklist[index].checklist}');
                                              //   },
                                              // ),
                                              // listLogs[index].desciption !=
                                              //         ''
                                              //     ?
                                              const Row(
                                                children: [
                                                  Icon(
                                                      Icons.description_rounded,
                                                      size: 25),
                                                  SizedBox(width: 5),
                                                  Text('รายละเอียดเพิ่มเติม'),
                                                ],
                                              ),
                                              // : Container(),
                                              // fileList[index].desciption !=
                                              //         ''
                                              //     ?
                                              // Padding(
                                              //   padding:
                                              //       const EdgeInsets.symmetric(
                                              //           horizontal: 20,
                                              //           vertical: 3),
                                              //   child: Text(
                                              //     '- ${fileList[index].desciption}',
                                              //   ),
                                              // ),
                                              // : Container(),

                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.photo_library_rounded,
                                                    size: 30,
                                                    color: Colors.black,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Expanded(
                                                      child: Text(
                                                          'รูปภาพการตรวจ')),
                                                  button(
                                                      'ดูรูปภาพ',
                                                      Theme.of(context)
                                                          .primaryColor,
                                                      Icons.photo, () {
                                                    _getLogImages(
                                                        fileList[index].sId!);
                                                  })
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_sharp,
                                                    size: 30,
                                                    color: Colors.red.shade600,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Expanded(
                                                      child: Text(
                                                          'ตำแหน่งที่ตรวจ')),
                                                  button(
                                                      'ดูตำแหน่ง',
                                                      Colors.red.shade600,
                                                      Icons.map, () {
                                                    showMap(
                                                        fileList[index].lat!,
                                                        fileList[index].lng!);
                                                  })
                                                ],
                                              ),
                                              // SizedBox(height: 5),
                                              // Map_Page(
                                              //   lat: listLogs[index].lat!,
                                              //   lng: listLogs[index].lng!,
                                              //   width: double.infinity,
                                              //   height: 200,
                                              // )
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
            )),
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
