import 'dart:developer';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/list_logo_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_bar.dart';
import 'package:doormster/models/get_logs.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Record_Check extends StatefulWidget {
  final dateValue;
  const Record_Check({Key? key, this.dateValue});

  @override
  State<Record_Check> createState() => _Record_CheckState();
}

class _Record_CheckState extends State<Record_Check> {
  var companyId;
  TextEditingController fieldText = TextEditingController();
  List<Data> listlogs = [];
  List<Data> listdata = [];
  bool loading = false;
  DateFormat formatTime = DateFormat.Hm();
  DateFormat formatDate = DateFormat('y-MM-dd');
  DateTime now = DateTime.now();
  String? dateNow;

  Future _getLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');
    dateNow = DateFormat('y-MM-dd').format(now);
    fieldText = TextEditingController(text: dateNow);

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
        getLogs logslist = getLogs.fromJson(response.data);
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
        Navigator.popUntil(context, (route) => route.isFirst);
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  void _searchData(String text) {
    setState(() {
      listlogs = listdata.where((item) {
        var date = item.date!.toLowerCase();
        return date.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getLogs();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('บันทึกรายการตรวจ'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }),
            ),
            body: loading
                ? Container()
                : SafeArea(
                    child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Search_Bar(
                            title: 'ค้นหา',
                            fieldText: fieldText,
                            changed: (value) {
                              _searchData(value);
                            },
                            ontap: () {
                              calendar(context);
                            },
                            clear: () {
                              setState(() {
                                fieldText.text == '';
                              });
                              fieldText.clear();
                              _getLogs();
                            }),
                      ),
                      Expanded(
                        child: listlogs.isEmpty
                            ? Logo_Opacity()
                            : ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                // shrinkWrap: true,
                                // primary: false,
                                // reverse: true
                                itemCount: listlogs.length,
                                itemBuilder: ((context, index) {
                                  DateTime time = DateTime.parse(
                                      '${listlogs[index].checktimeReal}');
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    elevation: 10,
                                    child: Container(
                                      // decoration: BoxDecoration(
                                      //     color: containerColor,
                                      //     borderRadius: BorderRadius.circular(10)),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // now.isAfter(timeStart) &&
                                          //         now.isBefore(timeEnd)
                                          //     ? Column(
                                          //         children: [
                                          //           Text(
                                          //             'รอบที่ต้องเดินตรวจ',
                                          //             style: TextStyle(
                                          //                 color: textColor),
                                          //           ),
                                          //           Divider(
                                          //               height: 15,
                                          //               thickness: 1.5,
                                          //               color: line),
                                          //         ],
                                          //       )
                                          //     : Container(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'เหตุการณ์ : ${listlogs[index].event}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                              height: 15,
                                              thickness: 1.5,
                                              color: Colors.black),
                                          IntrinsicHeight(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'วันที่ : ${listlogs[index].date}',
                                                ),
                                                VerticalDivider(
                                                    thickness: 1.5,
                                                    color: Colors.black,
                                                    width: 1),
                                                Text(
                                                  'เวลา : ${formatTime.format(time)}',
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                  // : Container();
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

  void calendar(context) async {
    DateTime? _startDate;
    DateTime? _endDate;
    String? _startDateText;
    String? _endDateText;
    String? dateDifferent;
    final datePicker = await showCalendarDatePicker2Dialog(
      context: context,
      initialValue: _pickerValue,
      config: CalendarDatePicker2WithActionButtonsConfig(
          firstDayOfWeek: 1,
          weekdayLabelTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).primaryColor),
          centerAlignModePickerButton: true,
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
      dialogSize: const Size(300, 400),
      borderRadius: BorderRadius.circular(10),
    );

    if (datePicker != null) {
      if (datePicker.length == 2) {
        setState(() {
          _startDate = datePicker[0]!;
          _endDate = datePicker[1]!;

          _startDateText = formatDate.format(_startDate!);
          _endDateText = formatDate.format(_endDate!);

          dateDifferent = "${_startDateText} ถึง ${_endDateText}";
          fieldText.text = dateDifferent!;

          _searchData(dateDifferent!);
        });
      } else if (datePicker.length == 1) {
        setState(() {
          _startDate = datePicker[0]!;
          _endDate = datePicker[0]!;

          _startDateText = formatDate.format(_startDate!);
          _endDateText = formatDate.format(_endDate!);

          fieldText.text = _startDateText!;
          _searchData(_startDateText!);
        });
      }
      setState(() {
        _pickerValue = datePicker;
        print(_pickerValue);
      });
    }
  }
}
