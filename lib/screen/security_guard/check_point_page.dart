// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_logo_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
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
  bool loading = false;

  Future _getCheckPoint() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
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

  @override
  void initState() {
    super.initState();
    _getCheckPoint();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('รายการจุดตรวจ')),
          body: loading
              ? Container()
              : SafeArea(
                  child: listdata.isEmpty
                      ? Logo_Opacity()
                      : SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: ListView.builder(
                                shrinkWrap: true,
                                primary: false,
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
                                              'จุดตรวจ :  ${listdata[index].checkpointName}'),
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                      bottomRight: Radius.circular(
                                                          10)), // Set the border radius here
                                                  color: Colors.grey.shade200),
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: listdata[index].verify == 0
                                                  ? Row(
                                                      children: [
                                                        Icon(
                                                          Icons.warning_rounded,
                                                          size: 30,
                                                          color: Colors.orange,
                                                        ),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            'ยังไม่ลงทะเบียนจุดตรวจนี้'),
                                                      ],
                                                    )
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .task_rounded,
                                                                size: 25),
                                                            SizedBox(width: 5),
                                                            Text('รายการตรวจ'),
                                                          ],
                                                        ),
                                                        ListView.builder(
                                                          shrinkWrap: true,
                                                          primary: false,
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  20, 5, 20, 5),
                                                          itemCount:
                                                              listcheckpoint
                                                                  ?.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return listcheckpoint?[
                                                                            index]
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
                                                                  Icon(
                                                                    Icons
                                                                        .location_on_sharp,
                                                                    size: 30,
                                                                    color: Colors
                                                                        .red
                                                                        .shade600,
                                                                  ),
                                                                  SizedBox(
                                                                      width: 5),
                                                                  Expanded(
                                                                    child: Text(
                                                                        'ตำแหน่งจุดตรวจ'),
                                                                  ),
                                                                  button(
                                                                      'ดูตำแหน่ง',
                                                                      Colors.red
                                                                          .shade600,
                                                                      Icons.map,
                                                                      () {
                                                                    showMap(
                                                                        listdata[index]
                                                                            .checkpointLat!,
                                                                        listdata[index]
                                                                            .checkpointLng!);
                                                                  })
                                                                ],
                                                              ),
                                                        // SizedBox(height: 5),
                                                        // Map_Page(
                                                        //   lat: listdata[index]
                                                        //       .checkpointLat!,
                                                        //   lng: listdata[index]
                                                        //       .checkpointLng!,
                                                        //   width:
                                                        //       double.infinity,
                                                        //   height: 200,
                                                        // )
                                                      ],
                                                    ),
                                            ),
                                          ]),
                                    ),
                                  );
                                }),
                          ),
                        )),
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
              insetPadding: EdgeInsets.symmetric(vertical: 180, horizontal: 30),
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
