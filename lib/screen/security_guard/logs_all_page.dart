// ignore_for_file: unused_import, avoid_print, use_build_context_synchronously

import 'dart:developer';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_calendar.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/models/get_logs_all.dart';
import 'package:doormster/screen/security_guard/record_point_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:dotted_line/dotted_line.dart';
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
  TextEditingController searchText = TextEditingController();
  List<DataLog> listLog = [];
  List<DataLog> listData = [];
  bool loading = false;
  DateFormat formatDate = DateFormat('y-MM-dd');
  DateTime now = DateTime.now();
  String? dateNow;
  var language;

  Future _getLog(String dateStart, String dateEnd, int loadingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');

    try {
      setState(() {
        if (loadingTime == 0) {
          loading = false;
        } else {
          loading = true;
        }
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
          listData = listLog;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(const Duration(milliseconds: 500));
      error_connected(context, () {
        homeKey.currentState?.popUntil(ModalRoute.withName('/security'));
        Navigator.of(context, rootNavigator: true).pop();
      });
      setState(() {
        loading = false;
      });
    }
  }

  void dateNowAll() async {
    _startDateText = formatDate.format(now);
    _endDateText = formatDate.format(now);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    dateNow = DateFormat('dd-MM-y').format(now);
    if (language == 'en') {
      fieldText = TextEditingController(text: 'Select Date ($dateNow)');
    } else {
      fieldText = TextEditingController(text: 'เลือกวันที่ ($dateNow)');
    }
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      _getLog(_startDateText!, _endDateText!, 0);
    });
  }

  void _searchData(String text) {
    setState(() {
      listLog = listData.where((item) {
        var name = item.roundName!.toLowerCase();
        return name.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    dateNowAll();
    _getLog(_startDateText!, _endDateText!, 1);
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
                        margin: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                        child: Column(
                          children: [
                            Search_Calendar(
                              title: 'search'.tr,
                              fieldText: fieldText,
                              ontap: () {
                                calendar(context);
                              },
                              clear: () {
                                setState(() {
                                  dateNowAll();
                                  _getLog(_startDateText!, _endDateText!, 0);
                                  _pickerValue = [DateTime.now()];
                                });
                              },
                            ),
                            listData.length > 10
                                ? Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: DottedLine(
                                          direction: Axis.horizontal,
                                          alignment: WrapAlignment.center,
                                          lineLength: double.infinity,
                                          lineThickness: 2,
                                          dashColor: Colors.grey.shade600,
                                          dashGapColor: Colors.white,
                                        ),
                                      ),
                                      Search_From(
                                        title: 'search_round'.tr,
                                        fieldText: searchText,
                                        clear: () {
                                          setState(() {
                                            searchText.clear();
                                            listLog = listData;
                                          });
                                        },
                                        changed: (value) {
                                          _searchData(value);
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: listLog.isEmpty
                            ? Logo_Opacity(title: 'data_not_found'.tr)
                            : RefreshIndicator(
                                onRefresh: () async {
                                  _getLog(_startDateText!, _endDateText!, 500);
                                },
                                child: ListView.builder(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 5),
                                    itemCount: listLog.length,
                                    itemBuilder: ((context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
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
                                                          roundName: listLog[
                                                                          index]
                                                                      .roundName ==
                                                                  'นอกรอบ'
                                                              ? 'extra_round'.tr
                                                              : '${listLog[index].roundName}',
                                                          roundStart:
                                                              listLog[index]
                                                                  .roundStart,
                                                          roundEnd:
                                                              listLog[index]
                                                                  .roundEnd,
                                                          dateTime: fieldText
                                                                      .text
                                                                      .contains(
                                                                          'วันที่') ||
                                                                  fieldText.text
                                                                      .contains(
                                                                          'Select')
                                                              ? dateNow
                                                              : fieldText.text,
                                                        )))
                                                .then(onGoBack);
                                          },
                                          child: Container(
                                            // decoration: BoxDecoration(
                                            //     color: containerColor,
                                            //     borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${'round'.tr} : ${listLog[index].roundName == 'นอกรอบ' ? 'extra_round'.tr : listLog[index].roundName}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Icon(Icons
                                                        .arrow_forward_ios_rounded)
                                                  ],
                                                ),
                                                listLog[index].roundName ==
                                                        'นอกรอบ'
                                                    ? Container()
                                                    : IntrinsicHeight(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                '${'start'.tr} : ${listLog[index].roundStart}'),
                                                            const VerticalDivider(
                                                                thickness: 1.5,
                                                                color: Colors
                                                                    .black,
                                                                width: 1),
                                                            Text(
                                                                '${'end'.tr} : ${listLog[index].roundEnd}'),
                                                          ],
                                                        ),
                                                      ),
                                                listLog[index]
                                                        .fileList!
                                                        .isNotEmpty
                                                    ? Text(
                                                        '${'record'.tr} ${listLog[index].fileList?.length} ${'list'.tr}',
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      )
                                                    : Text(
                                                        'no_record'.tr,
                                                        style: const TextStyle(
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
          yearTextStyle: const TextStyle(fontWeight: FontWeight.normal),
          firstDayOfWeek: 1,
          weekdayLabelTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Theme.of(context).primaryColor),
          centerAlignModePicker: true,
          lastDate: DateTime.now(),
          calendarType: CalendarDatePicker2Type.range,
          cancelButton: Text(
            'cancel'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          okButton: Text(
            'ok'.tr,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          )),
      dialogSize: const Size(300, 400),
      borderRadius: BorderRadius.circular(10),
    );

    if (datePicker != null) {
      //เลือก 2 วันที่
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
          var _ShowStartDate = dateShow.format(_startDate!);
          var _ShowEndDateText = dateShow.format(_endDate!);

          //fieldText Controller
          if (language == 'en') {
            dateDifferent = "${_ShowStartDate} to ${_ShowEndDateText}";
          } else {
            dateDifferent = "${_ShowStartDate} ถึง ${_ShowEndDateText}";
          }
          fieldText.text = dateDifferent!;
        });

        //เลือก 1 วันที่
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
          var _ShowStartDate = dateShow.format(_startDate!);

          //fieldText Controller
          fieldText.text = _ShowStartDate;
        });
      }
      setState(() {
        _pickerValue = datePicker;
        log('_pickerValue ${_pickerValue}');
      });
    }
  }
}
