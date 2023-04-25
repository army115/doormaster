import 'dart:developer';
import 'dart:io';
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

class Record_Check extends StatefulWidget {
  final dateValue;
  final type;
  Record_Check({Key? key, this.dateValue, this.type});

  @override
  State<Record_Check> createState() => _Record_CheckState();
}

class _Record_CheckState extends State<Record_Check> {
  String? companyId;
  TextEditingController fieldText = TextEditingController();
  List<DatalogAll> listlogs = [];
  List<DatalogAll> listdata = [];
  List<DataLog> listLog = [];
  int? listLength = 0;
  bool loading = false;
  DateFormat formatTime = DateFormat.Hm();
  DateFormat formatDate = DateFormat('y-MM-dd');
  DateTime now = DateTime.now();
  String? dateNow;

  Future _getLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');

    try {
      setState(() {
        loading = true;
      });

      //call api
      var url = '${Connect_api().domain}/get/logshow/${companyId}';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getLogsAll logslist = getLogsAll.fromJson(response.data);
        setState(() {
          listlogs = logslist.data!;
          listdata = listlogs;
          _searchData('$dateNow');
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

  Future _getLog(String dateStart, String dateEnd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');

    try {
      setState(() {
        loading = true;
      });

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
    dateNow = DateFormat('y-MM-dd').format(now);
    fieldText = TextEditingController(text: dateNow);
    _startDateText = dateNow;
    _endDateText = dateNow;
  }

  void _searchData(String text) {
    setState(() {
      listlogs = listdata.where((item) {
        var date = item.date!.toLowerCase();
        return date.contains(text);
      }).toList();
    });
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      _getLog(_startDateText!, _endDateText!);
    });
  }

  @override
  void initState() {
    super.initState();
    dateNowAll();
    // _getLogs();
    // _getCheckPoint();
    _getLog(_startDateText!, _endDateText!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.type != null) {
          Navigator.of(context).pop();
        } else {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('บันทึกรายการตรวจ'),
              leading: button_back(() {
                if (widget.type != null) {
                  Navigator.of(context).pop();
                } else {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }
              }),
            ),
            body: loading
                ? Container()
                : SafeArea(
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Search_Calendar(
                          title: 'ค้นหา',
                          fieldText: fieldText,
                          ontap: () {
                            calendar(context);
                          },
                          // changed: (value) {
                          //   _getLog(_startDateText!, _endDateText!);
                          // _searchData(value);
                          // },
                          // clear: () {
                          //   setState(() {
                          //     fieldText.text == '';
                          //   });
                          //   fieldText.clear();
                          //   _getLogs();
                          // }
                        ),
                      ),
                      Expanded(
                        child: listLog.isEmpty
                            //?listlogs.isEmpty
                            ? Logo_Opacity(title: 'ไม่มีข้อมูลที่บันทึก')
                            : ListView.builder(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                                // shrinkWrap: true,
                                // primary: false,
                                // reverse: true
                                itemCount: listLog.length, //?listlogs.length
                                itemBuilder: ((context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    elevation: 10,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    Record_Point(
                                                      listPoint: listLog[index]
                                                          .fileList,
                                                    )))
                                            .then((onGoBack));
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Icon(Icons
                                                    .arrow_forward_ios_rounded)
                                              ],
                                            ),
                                            Text('วันที่ : ${fieldText.text}'),
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })),
                      ),
                    ],
                  )),
          ),
          loading ? Loading() : Container()
        ],
      ),
    );
  }

  List<DateTime?> _pickerValue = [DateTime.now()];
  DateTime? _startDate;
  DateTime? _endDate;
  String? _startDateText;
  String? _endDateText;
  String? dateDifferent;

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
          _startDate = datePicker[0]!;
          _endDate = datePicker[1]!;

          _startDateText = formatDate.format(_startDate!);
          _endDateText = formatDate.format(_endDate!);

          dateDifferent = "${_startDateText} ถึง ${_endDateText}";
          fieldText.text = dateDifferent!;

          _getLog(_startDateText!, _endDateText!);
          // _searchData(dateDifferent!);
        });
      } else if (datePicker.length == 1) {
        setState(() {
          _startDate = datePicker[0]!;
          _endDate = datePicker[0]!;

          _startDateText = formatDate.format(_startDate!);
          _endDateText = formatDate.format(_endDate!);

          fieldText.text = _startDateText!;

          _getLog(_startDateText!, _endDateText!);
          // _searchData(_startDateText!);
        });
      }
      setState(() {
        _pickerValue = datePicker;
        log('_pickerValue ${_pickerValue}');
      });
    }
  }
}
