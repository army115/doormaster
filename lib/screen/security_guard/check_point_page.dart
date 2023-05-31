// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Check_Point extends StatefulWidget {
  Check_Point({Key? key}) : super(key: key);

  @override
  State<Check_Point> createState() => _Check_PointState();
}

class _Check_PointState extends State<Check_Point> {
  var companyId;
  List<Data> listdata = [];
  List<Data> listPoint = [];
  bool loading = false;
  TextEditingController fieldText = TextEditingController();

  Future _getCheckPoint(loadingTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    print('companyId: ${companyId}');

    try {
      setState(() {
        loading = true;
      });

      await Future.delayed(Duration(milliseconds: loadingTime));

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
          listPoint = listdata;
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

  void _searchData(String text) {
    setState(() {
      listdata = listPoint.where((item) {
        var name = item.checkpointName!.toLowerCase();
        return name.contains(text);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCheckPoint(300);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('รายการจุดตรวจ')),
          body: loading
              ? Container()
              : Column(
                  children: [
                    listPoint.length > 8
                        ? Container(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: Search_From(
                              title: 'ค้นหาจุดตรวจ',
                              fieldText: fieldText,
                              clear: () {
                                setState(() {
                                  fieldText.clear();
                                  listdata = listPoint;
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
                          ? Logo_Opacity(title: 'ไม่มีข้อมูลที่บันทึก')
                          : RefreshIndicator(
                              onRefresh: () async {
                                _getCheckPoint(500);
                              },
                              child: ListView.builder(
                                  padding: listdata.length > 8
                                      ? const EdgeInsets.fromLTRB(20, 0, 20, 10)
                                      : const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 20),
                                  itemCount: listdata.length,
                                  itemBuilder: (context, index) {
                                    final listcheckpoint =
                                        listdata[index].checklist;
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      elevation: 10,
                                      child: Container(
                                        child: ExpansionTile(
                                            textColor: Colors.black,
                                            title: Text(
                                              'จุดตรวจ :  ${listdata[index].checkpointName}',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            subtitle: textDoubleColors(
                                                'สถานะ : ',
                                                Colors.black,
                                                listdata[index].verify == 0
                                                    ? 'ยังไม่ลงทะเบียน'
                                                    : 'ลงทะเบียนแล้ว',
                                                listdata[index].verify == 0
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .primaryColor),
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(
                                                                10)), // Set the border radius here
                                                    color:
                                                        Colors.grey.shade200),
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                child:
                                                    listdata[index].verify == 0
                                                        ? textIcon(
                                                            'ยังไม่ลงทะเบียนจุดตรวจนี้',
                                                            const Icon(
                                                              Icons
                                                                  .warning_rounded,
                                                              size: 30,
                                                              color:
                                                                  Colors.orange,
                                                            ),
                                                          )
                                                        : Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              textIcon(
                                                                'รายการตรวจ',
                                                                const Icon(
                                                                    Icons
                                                                        .task_rounded,
                                                                    size: 28),
                                                              ),
                                                              ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                primary: false,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            3,
                                                                        horizontal:
                                                                            20),
                                                                itemCount:
                                                                    listcheckpoint
                                                                        ?.length,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return listcheckpoint?[index]
                                                                              .checklist ==
                                                                          ''
                                                                      ? Container()
                                                                      : Text(
                                                                          '- ${listcheckpoint?[index].checklist}');
                                                                },
                                                              ),
                                                              listdata[index]
                                                                          .verify ==
                                                                      0
                                                                  ? Container()
                                                                  : Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              textIcon(
                                                                            'ตำแหน่งจุดตรวจ',
                                                                            const Icon(Icons.location_on_sharp,
                                                                                color: Colors.red,
                                                                                size: 28),
                                                                          ),
                                                                        ),
                                                                        button(
                                                                            'ดูตำแหน่ง',
                                                                            Colors
                                                                                .red.shade600,
                                                                            Icons.map,
                                                                            () {
                                                                          showMap(
                                                                              listdata[index].checkpointLat!,
                                                                              listdata[index].checkpointLng!);
                                                                        })
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                              ),
                                            ]),
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

  void showMap(lat, lng) {
    showDialog(
        useRootNavigator: true,
        context: context,
        builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.symmetric(vertical: 150, horizontal: 20),
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
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 3),
          Text(
            name,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
          ),
        ],
      ),
      onPressed: press,
    );
  }
}
