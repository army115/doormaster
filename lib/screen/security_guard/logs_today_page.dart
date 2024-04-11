// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/screen/security_guard/logs_point_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dotted_line/dotted_line.dart';

class Logs_Today extends StatefulWidget {
  const Logs_Today({super.key});

  @override
  State<Logs_Today> createState() => _Logs_TodayState();
}

class _Logs_TodayState extends State<Logs_Today>
    with AutomaticKeepAliveClientMixin {
  List<DataLog> listdata = [];
  List<DataLog> listlogs = [];
  List<Data> listPoint = [];
  TextEditingController fieldText = TextEditingController();
  bool loading = false;
  DateTime now = DateTime.now();

  Future _getLog(int loadingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');
    String date = DateFormat('y-MM-dd').format(now);

    try {
      setState(() {
        if (loadingTime == 0) {
          loading = false;
        } else {
          loading = true;
        }
      });

      await Future.delayed(Duration(milliseconds: loadingTime));

      //call api get RoundNoPic
      var url = '${Connect_api().domain}/get/getRoundNoPic';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: {"id": companyId, "from": date, "to": date});

      //call api get checkpoint
      var urlPoint = '${Connect_api().domain}/get/checkpoint/${companyId}';
      var resPoint = await Dio().get(
        urlPoint,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200 && resPoint.statusCode == 200) {
        getLog logslist = getLog.fromJson(response.data);
        getChecklist checklist = getChecklist.fromJson(response.data);
        setState(() {
          listdata = logslist.data!;
          listlogs = listdata;
          listPoint = checklist.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(const Duration(milliseconds: 500));
      error_connected(() {
        homeKey.currentState?.popUntil(ModalRoute.withName('/security'));
        Navigator.of(context, rootNavigator: true).pop();
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future onGoBack(dynamic value) async {
    setState(() {
      _getLog(0);
    });
  }

  void _searchData(String text) {
    setState(() {
      listdata = listlogs.where((item) {
        var name = item.roundName!;
        return name.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getLog(1);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dateNow = DateFormat('dd-MM-y').format(now);
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
                          Card(
                            elevation: 10,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: textIcon(
                                    '${'date_report'.tr} : $dateNow',
                                    Icon(
                                      Icons.event_note,
                                      color: Theme.of(context).primaryColorDark,
                                      size: 25,
                                    ))),
                          ),
                          listlogs.length > 10
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
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Expanded(
                        child: listdata.isEmpty
                            ? Logo_Opacity(title: 'data_not_found'.tr)
                            : RefreshIndicator(
                                onRefresh: () async {
                                  _getLog(500);
                                },
                                child: ListView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 10),
                                    itemCount: listdata.length,
                                    itemBuilder: ((context, ndex) {
                                      //  เริ่มที่ index 1
                                      final index = ndex + 1;
                                      //ปิด index แรก
                                      if (index >= listdata.length) {
                                        return Container();
                                      }
                                      final logsPoint =
                                          listdata[index].fileList!.length;
                                      final checkPoint = listPoint.length;

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
                                                        Logs_Point(
                                                          roundId:
                                                              listdata[index]
                                                                  .roundUuid,
                                                          roundName:
                                                              listdata[index]
                                                                  .roundName,
                                                          roundStart:
                                                              listdata[index]
                                                                  .roundStart,
                                                          roundEnd:
                                                              listdata[index]
                                                                  .roundEnd,
                                                        )))
                                                .then(onGoBack);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        '${'round'.tr} : ${listdata[index].roundName}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: Get.textTheme
                                                          .bodyText2?.color,
                                                    )
                                                  ],
                                                ),
                                                IntrinsicHeight(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${'start'.tr} : ${listdata[index].roundStart}'),
                                                      const VerticalDivider(
                                                          thickness: 1.5,
                                                          color: Colors.black,
                                                          width: 1),
                                                      Text(
                                                          '${'end'.tr} : ${listdata[index].roundEnd}'),
                                                    ],
                                                  ),
                                                ),
                                                logsPoint <= 0
                                                    ? Text(
                                                        '${'not_checked'.tr} ($logsPoint/$checkPoint)',
                                                        style: TextStyle(
                                                            color: Colors.red))
                                                    : logsPoint >= checkPoint
                                                        ? Text(
                                                            '${'checked_complete'.tr} ($logsPoint/$checkPoint)',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorDark))
                                                        : Text(
                                                            '${'checked_incomplete'.tr} ($logsPoint/$checkPoint)',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .orange)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    })),
                              )),
                  ],
                ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }
}
