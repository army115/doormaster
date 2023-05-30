// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/models/get_log.dart';
import 'package:doormster/screen/security_guard/logs_point_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logs_Today extends StatefulWidget {
  const Logs_Today({super.key});

  @override
  State<Logs_Today> createState() => _Logs_TodayState();
}

class _Logs_TodayState extends State<Logs_Today>
    with AutomaticKeepAliveClientMixin {
  var companyId;
  List<DataLog> listdata = [];
  bool loading = false;
  DateTime now = DateTime.now();

  Future _getLog(int loadingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');
    String date = DateFormat('y-MM-dd').format(now);

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
          data: {"id": companyId, "from": date, "to": date});

      if (response.statusCode == 200) {
        getLog logslist = getLog.fromJson(response.data);
        setState(() {
          listdata = logslist.data!;
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
      _getLog(0);
    });
  }

  @override
  void initState() {
    super.initState();
    _getLog(300);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final dateNow = DateFormat('dd-MM-y').format(now);
    return Stack(
      children: [
        Stack(
          children: [
            Scaffold(
              body: loading
                  ? Container()
                  : SafeArea(
                      child: listdata.isEmpty
                          //?listlogs.isEmpty
                          ? Logo_Opacity(title: 'ไม่มีข้อมูลที่บันทึก')
                          : Column(
                              children: [
                                Container(
                                  height: 80,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 10,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.event_note,
                                          color: Theme.of(context).primaryColor,
                                          size: 30,
                                        ),
                                        SizedBox(width: 5),
                                        Text('รายงานวันที่ : $dateNow'),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RefreshIndicator(
                                      onRefresh: () async {
                                        _getLog(500);
                                      },
                                      child: ListView.builder(
                                          physics:
                                              const AlwaysScrollableScrollPhysics(),
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 5),
                                          // shrinkWrap: true,
                                          // primary: false,
                                          // reverse: true
                                          itemCount: listdata
                                              .length, //?listlogs.length
                                          itemBuilder: ((context, index) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              elevation: 10,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                onTap: () {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  Logs_Point(
                                                                    // fileList: listdata[
                                                                    //         index]
                                                                    // .fileList,
                                                                    roundId: listdata[
                                                                            index]
                                                                        .roundUuid,
                                                                    roundName: listdata[
                                                                            index]
                                                                        .roundName,
                                                                    roundStart:
                                                                        listdata[index]
                                                                            .roundStart,
                                                                    roundEnd: listdata[
                                                                            index]
                                                                        .roundEnd,
                                                                  )))
                                                      .then(onGoBack);
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              'รอบเดิน : ${listdata[index].roundName}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          const Icon(Icons
                                                              .arrow_forward_ios_rounded)
                                                        ],
                                                      ),
                                                      IntrinsicHeight(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'เริ่มต้น : ${listdata[index].roundStart} น.'),
                                                            const VerticalDivider(
                                                                thickness: 1.5,
                                                                color: Colors
                                                                    .black,
                                                                width: 1),
                                                            Text(
                                                              'สิ้นสุด : ${listdata[index].roundEnd} น.',
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      listdata[index]
                                                                  .fileList!
                                                                  .length >
                                                              0
                                                          ? Text(
                                                              'มีบันทึก ${listdata[index].fileList?.length} รายการ',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                            )
                                                          : const Text(
                                                              'ไม่มีบันทึกรายการตรวจ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }))),
                                ),
                              ],
                            ),
                    ),
            ),
            loading ? Loading() : Container()
          ],
        ),
        loading ? Loading() : Container()
      ],
    );
  }
}
