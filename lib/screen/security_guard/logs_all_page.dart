// ignore_for_file: prefer_const_constructors, prefer_is_empty, use_build_context_synchronously, unused_import

import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_calendar.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/models/get_logs_all.dart';
import 'package:doormster/screen/security_guard/record_point_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logs_All extends StatefulWidget {
  final dateValue;
  final type;
  Logs_All({Key? key, this.dateValue, this.type});

  @override
  State<Logs_All> createState() => _Logs_AllState();
}

class _Logs_AllState extends State<Logs_All>
    with AutomaticKeepAliveClientMixin {
  String? companyId;
  TextEditingController fieldText = TextEditingController();
  List<DataLog> listLog = [];
  bool loading = false;
  DateFormat formatDate = DateFormat('y-MM-dd');
  DateTime now = DateTime.now();
  String? dateNow;

  Future _getLog(String dateStart, String dateEnd, int loadingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');

    try {
      setState(() {
        loading = true;
      });

      await Future.delayed(Duration(milliseconds: loadingTime));

      //call api
      var url = '${Connect_api().domain}/get/getRoundNoPic';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: {"id": companyId, "from": dateStart, "to": dateEnd});

      if (response.statusCode == 200) {
        getLog logslist = getLog.fromJson(response.data);
        setState(() {
          listLog = logslist.data!;
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

  void dateNowAll() {
    dateNow = DateFormat('dd-MM-y').format(now);
    fieldText = TextEditingController(text: 'ค้นหาข้อมูล ($dateNow)');
    _startDateText = formatDate.format(now);
    _endDateText = formatDate.format(now);
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      _getLog(_startDateText!, _endDateText!, 0);
    });
  }

  @override
  void initState() {
    super.initState();
    dateNowAll();
    _getLog(_startDateText!, _endDateText!, 300);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Scaffold(
            body: loading
                ? Container()
                : Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                        child: Search_Calendar(
                          title: 'ค้นหา',
                          fieldText: fieldText,
                          ontap: () {
                            calendar(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: listLog.isEmpty
                            ? Logo_Opacity(title: 'ไม่มีข้อมูลที่บันทึก')
                            : RefreshIndicator(
                                onRefresh: () async {
                                  _getLog(_startDateText!, _endDateText!, 500);
                                },
                                child: ListView.builder(
                                    padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                                    itemCount: listLog.length,
                                    itemBuilder: ((context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        elevation: 10,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        Record_Point(
                                                          fileList:
                                                              listLog[index]
                                                                  .fileList,
                                                          roundName:
                                                              listLog[index]
                                                                  .roundName,
                                                          roundStart:
                                                              listLog[index]
                                                                  .roundStart,
                                                          roundEnd:
                                                              listLog[index]
                                                                  .roundEnd,
                                                          dateTime: fieldText
                                                                  .text
                                                                  .contains(
                                                                      'ค้นหา')
                                                              ? dateNow
                                                              : fieldText.text,
                                                        )))
                                                .then(onGoBack);
                                          },
                                          child: Container(
                                            // decoration: BoxDecoration(
                                            //     color: containerColor,
                                            //     borderRadius: BorderRadius.circular(10)),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        'รอบเดิน : ${listLog[index].roundName}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Icon(Icons
                                                        .arrow_forward_ios_rounded)
                                                  ],
                                                ),
                                                // Text(
                                                //     'วันที่ : ${fieldText.text}'),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          'เริ่มต้น : ${listLog[index].roundStart} น.'),
                                                      VerticalDivider(
                                                          thickness: 1.5,
                                                          color: Colors.black,
                                                          width: 1),
                                                      Text(
                                                        'สิ้นสุด : ${listLog[index].roundEnd} น.',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                listLog[index]
                                                            .fileList!
                                                            .length >
                                                        0
                                                    ? Text(
                                                        'มีบันทึก ${listLog[index].fileList?.length} รายการ',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      )
                                                    : Text(
                                                        'ไม่มีบันทึกรายการตรวจ',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              ),
                      ),
                    ],
                  )),
        loading ? Loading() : Container()
      ],
    );
  }

  List<DateTime?> _pickerValue = [DateTime.now()];
  DateTime? _startDate;
  DateTime? _endDate;
  String? _startDateText;
  String? _endDateText;
  String? dateDifferent;
  DateFormat dateShow = DateFormat('dd-MM-y');

  void calendar(context) async {
    final datePicker = await showCalendarDatePicker2Dialog(
      context: context,
      value: _pickerValue,
      config: CalendarDatePicker2WithActionButtonsConfig(
          yearTextStyle: TextStyle(fontWeight: FontWeight.normal),
          firstDayOfWeek: 1,
          weekdayLabelTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).primaryColor),
          centerAlignModePicker: true,
          lastDate: DateTime.now(),
          calendarType: CalendarDatePicker2Type.range,
          cancelButton: Text(
            'ยกเลิก',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          okButton: Text(
            'ตกลง',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          )),
      dialogSize: Size(300, 400),
      borderRadius: BorderRadius.circular(10),
    );

    if (datePicker != null) {
      if (datePicker.length == 2 && datePicker[0] != datePicker[1]) {
        setState(() {
          //date ที่ได้จากการเลือกในปฏิทิน
          _startDate = datePicker[0]!;
          _endDate = datePicker[1]!;

          //date ส่งไป get api
          _startDateText = formatDate.format(_startDate!);
          _endDateText = formatDate.format(_endDate!);

          //get date api
          _getLog(_startDateText!, _endDateText!, 300);

          //date ส่งไปแสดงหน้าแอพ
          _startDateText = dateShow.format(_startDate!);
          _endDateText = dateShow.format(_endDate!);

          //fieldText Controller
          dateDifferent = "${_startDateText} ถึง ${_endDateText}";
          fieldText.text = dateDifferent!;
        });
      } else if (datePicker.length == 1) {
        setState(() {
          //date ที่ได้จากการเลือกในปฏิทิน
          _startDate = datePicker[0]!;
          _endDate = datePicker[0]!;

          //date ส่งไป get api
          _startDateText = formatDate.format(_startDate!);
          _endDateText = formatDate.format(_endDate!);

          //get date api
          _getLog(_startDateText!, _endDateText!, 300);

          //date ส่งไปแสดงหน้าแอพ
          _startDateText = dateShow.format(_startDate!);
          _endDateText = dateShow.format(_endDate!);

          //fieldText Controller
          fieldText.text = _startDateText!;
        });
      }
      setState(() {
        _pickerValue = datePicker;
        log('_pickerValue ${_pickerValue}');
      });
    }
  }
}
