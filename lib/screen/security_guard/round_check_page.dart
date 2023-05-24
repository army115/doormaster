// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/models/get_round.dart';
import 'package:doormster/screen/security_guard/scan_qr_check_page.dart';
import 'package:doormster/service/check_connected.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_location.dart';
import 'package:flutter/material.dart';
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
  var companyId;
  List<Data> listdata = [];
  bool loading = false;
  Color? containerColor;
  Color? textColor;
  Color? line;
  DateTime now = DateTime.now();
  int round = 0;
  DateFormat format = DateFormat("HH:mm");

  Future _setColor(now, timeStart, timeEnd) async {
    if (timeEnd.isBefore(timeStart)) {
      if (now.isAfter(timeStart) ||
          now.isBefore(timeEnd) ||
          now.isAtSameMomentAs(timeStart) ||
          now.isAtSameMomentAs(timeEnd)) {
        containerColor = Theme.of(context).primaryColor;
        textColor = Colors.yellow;
        line = Colors.yellow;
        round = 1;
      } else {
        round = 0;
        containerColor = Colors.white;
        textColor = Colors.black;
        line = Colors.grey;
      }
    } else {
      if (now.isAfter(timeStart) && now.isBefore(timeEnd) ||
          now.isAtSameMomentAs(timeStart) ||
          now.isAtSameMomentAs(timeEnd)) {
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
          appBar: AppBar(title: Text('รายการรอบเดินตรวจ')),
          body: loading
              ? Container()
              : SafeArea(
                  child: listdata.isEmpty
                      ? Logo_Opacity(title: 'ไม่มีข้อมูลที่บันทึก')
                      : RefreshIndicator(
                          onRefresh: () async {
                            _getCheckRound(500);
                          },
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: listdata.length,
                              itemBuilder: (context, index) {
                                DateTime timeStart = DateTime.parse(
                                    '$date ${listdata[index].roundStart}');
                                DateTime timeEnd = DateTime.parse(
                                    '$date ${listdata[index].roundEnd}');
                                _setColor(now, timeStart, timeEnd);

                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'รอบเดิน : ${listdata[index].roundName}',
                                                maxLines: round == 1 ? 2 : 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                            ),
                                            round == 1
                                                ? button(
                                                    'เช็คจุดตรวจ', Colors.white,
                                                    () {
                                                    round != 1
                                                        ? permissionCamere(
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
                                                                            widget
                                                                                .checkpointId),
                                                                    true,
                                                                    onGoBack)))
                                                        : dialogOnebutton_Subtitle(
                                                            context,
                                                            'ไม่สามารถตรวจได้',
                                                            'เลยเวลาเดินตรวจรอบนี้แล้ว',
                                                            Icons
                                                                .warning_amber_rounded,
                                                            Colors.orange,
                                                            'ตกลง', () {
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pop();

                                                            // Navigator.popUntil(
                                                            //     context,
                                                            //     (route) => route
                                                            //         .isFirst);
                                                          }, false, false);
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
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                'เริ่มต้น : ${listdata[index].roundStart} น.',
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
                                              VerticalDivider(
                                                  thickness: 1.5,
                                                  color: line,
                                                  width: 1),
                                              Text(
                                                'สิ้นสุด : ${listdata[index].roundEnd} น.',
                                                style:
                                                    TextStyle(color: textColor),
                                              ),
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
