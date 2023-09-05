// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, unused_import

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/models/get_round.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Round_Check extends StatefulWidget {
  final checkpointId;
  Round_Check({Key? key, this.checkpointId}) : super(key: key);

  @override
  State<Round_Check> createState() => _Round_CheckState();
}

class _Round_CheckState extends State<Round_Check> {
  TextEditingController fieldText = TextEditingController();
  var companyId;
  List<Data> listdata = [];
  List<Data> listRound = [];
  bool loading = false;
  Color? containerColor;
  Color? textColor;
  Color? line;
  DateTime now = DateTime.now();
  int round = 0;
  DateFormat format = DateFormat("HH:mm");
  DateTime? timeStart;
  DateTime? timeEnd;

  Future _setColor() async {
    if (timeEnd!.isBefore(timeStart!)) {
      if (now.isAfter(timeStart!) ||
              now.isBefore(timeEnd!) ||
              now.isAtSameMomentAs(timeStart!)
          //  ||now.isAtSameMomentAs(timeEnd!)
          ) {
        containerColor = Theme.of(context).primaryColor;
        textColor = Colors.white;
        line = Colors.white;
        round = 1;
      } else {
        round = 0;
        containerColor = Colors.white;
        textColor = Colors.black;
        line = Colors.grey;
      }
    } else {
      if (now.isAfter(timeStart!) && now.isBefore(timeEnd!) ||
              now.isAtSameMomentAs(timeStart!)
          // || now.isAtSameMomentAs(timeEnd!)
          ) {
        containerColor = Theme.of(context).primaryColor;
        textColor = Colors.white;
        line = Colors.white;
        round = 1;
      } else {
        round = 0;
        containerColor = Colors.white;
        textColor = Colors.black;
        line = Colors.grey;
      }
    }
  }

  Future _getCheckRound(loadingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    now = DateTime.now();
    print('companyId: ${companyId}');

    try {
      setState(() {
        loading = true;
      });

      await Future.delayed(Duration(milliseconds: loadingTime));

      //call api
      var url = '${Connect_api().domain}/get/round/$companyId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getRound checklist = getRound.fromJson(response.data);
        setState(() {
          listdata = checklist.data!;
          listRound = listdata;
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

  Future onGoBack(dynamic value) async {
    setState(() {
      _getCheckRound(0);
    });
  }

  void _searchData(String text) {
    setState(() {
      listdata = listRound.where((item) {
        var name = item.roundName!.toLowerCase();
        return name.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCheckRound(300);
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('y-MM-dd').format(now);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('list_round'.tr)),
          body: loading
              ? Container()
              : Column(
                  children: [
                    listRound.length > 10
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: Search_From(
                              title: 'search_round'.tr,
                              fieldText: fieldText,
                              clear: () {
                                setState(() {
                                  fieldText.clear();
                                  listdata = listRound;
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
                                _getCheckRound(500);
                              },
                              child: ListView.builder(
                                  padding: listdata.length > 10
                                      ? const EdgeInsets.fromLTRB(20, 0, 20, 10)
                                      : const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                  itemCount: listdata.length,
                                  itemBuilder: (context, index) {
                                    timeStart = DateTime.parse(
                                        '$date ${listdata[index].roundStart}');
                                    timeEnd = DateTime.parse(
                                        '$date ${listdata[index].roundEnd}');
                                    _setColor();
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      elevation: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: containerColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            round == 1
                                                ? Column(
                                                    children: [
                                                      Text(
                                                        'รอบที่ต้องเดินตรวจ',
                                                        style: TextStyle(
                                                            color: textColor),
                                                      ),
                                                      Divider(
                                                          height: 15,
                                                          thickness: 1.5,
                                                          color: line),
                                                    ],
                                                  )
                                                : Container(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: textDoubleColors(
                                                        'round'.tr,
                                                        textColor,
                                                        ' : ${listdata[index].roundName}',
                                                        textColor)),
                                                round == 1
                                                    ? button('checkIn'.tr,
                                                        Colors.white, () {
                                                        permissionCamere(
                                                            context,
                                                            () => permissionLocation(
                                                                context,
                                                                () => checkInternetOnGoBack(
                                                                    context,
                                                                    ScanQR_Check(
                                                                        name:
                                                                            'check',
                                                                        roundId:
                                                                            listdata[index]
                                                                                .roundUuid!,
                                                                        roundName:
                                                                            listdata[index]
                                                                                .roundName!,
                                                                        roundStart:
                                                                            listdata[index]
                                                                                .roundStart!,
                                                                        roundEnd:
                                                                            listdata[index]
                                                                                .roundEnd!,
                                                                        checkpointId:
                                                                            widget.checkpointId),
                                                                    true,
                                                                    onGoBack)));
                                                        // : dialogOnebutton_Subtitle(
                                                        //     context,
                                                        //     'ไม่สามารถตรวจได้',
                                                        //     'เลยเวลาเดินตรวจรอบนี้แล้ว',
                                                        //     Icons
                                                        //         .warning_amber_rounded,
                                                        //     Colors.orange,
                                                        //     'ตกลง', () {
                                                        //     Navigator.of(
                                                        //             context,
                                                        //             rootNavigator:
                                                        //                 true)
                                                        //         .pop();
                                                        //   }, false, false);
                                                      })
                                                    : Container()
                                              ],
                                            ),
                                            Divider(
                                                height: 15,
                                                thickness: 1.5,
                                                color: line),
                                            IntrinsicHeight(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  textDoubleColors(
                                                      'start'.tr,
                                                      textColor,
                                                      ' : ${listdata[index].roundStart}',
                                                      textColor),
                                                  VerticalDivider(
                                                      thickness: 1.5,
                                                      color: line,
                                                      width: 1),
                                                  textDoubleColors(
                                                      'end'.tr,
                                                      textColor,
                                                      ' : ${listdata[index].roundEnd}',
                                                      textColor),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                    ),
                  ],
                ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }

  Widget button(name, color, press) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        primary: Colors.white,
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      child: Text(
        name,
        style: TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
      ),
      onPressed: press,
    );
  }
}
