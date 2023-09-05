// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/doors_device.dart';
import 'package:doormster/models/getdoor_wiegand.dart';
import 'package:doormster/models/opendoors_model.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/connect_native.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class Opendoor_Page extends StatefulWidget {
  Opendoor_Page({Key? key}) : super(key: key);

  @override
  State<Opendoor_Page> createState() => _Opendoor_PageState();
}

class _Opendoor_PageState extends State<Opendoor_Page> {
  var token;
  var companyId;
  var deviceId;
  var weiganId;

  TextEditingController fieldText = TextEditingController();

  List<Lists> listDevice = [];
  List<Lists> devicelidt = [];
  List<DataWiegand> listWeigan = [];
  List<Det>? listdet = [];
  List<Det>? detlist = [];
  bool loading = false;
  late SharedPreferences prefs;

  Future getValueShared() async {
    prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');
    companyId = prefs.getString('companyId');
    deviceId = prefs.getString('deviceId');
    weiganId = prefs.getString('weiganId');

    print('token: ${token}');
    print('companyId: ${companyId}');
    print('deviceId: ${deviceId}');
    print('weiganId: ${weiganId}');

    _getDoorDevice();
  }

  Future _getDoorDevice() async {
    try {
      setState(() {
        loading = true;
      });

      if (deviceId != null) {
        //call api device
        var url = '${Connect_api().domain}/getdeviceuuidmobile/$deviceId';
        var res = await Dio().get(
          url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
        );
        if (res.statusCode == 200) {
          if (res.data == 'มีบางอย่างผิดพลาด') {
            listDevice = [];
          } else {
            DoorsDeviece deviceDoors = DoorsDeviece.fromJson(res.data);
            setState(() {
              listDevice = deviceDoors.lists!;
              devicelidt = listDevice;
            });
          }
        }
      }

      //call api Weigan
      var urlWeigan =
          '${Connect_api().domain}/get/weigan_group_id/$weiganId/$companyId';
      var response = await Dio().get(
        urlWeigan,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        getDoorWiegand doorsWeigan = getDoorWiegand.fromJson(response.data);

        setState(() {
          listWeigan = doorsWeigan.data!;
          detlist = listdet;
          loading = false;
        });
        // วน loop เพื่อดึง Det จากแต่ละ DataWeigan
        for (int i = 0; i < listWeigan.length; i++) {
          // เก็บ List Det จาก DataWeigan ลงในตัวแปร listdet
          listdet?.addAll(listWeigan[i].det!);
        }
      }
    } catch (error) {
      print(error);
      if (deviceId == null) {
      } else {
        dialogOnebutton_Subtitle(
            context,
            'พบข้อผิดพลาด',
            'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
            Icons.warning_amber_rounded,
            Colors.orange,
            'ตกลง', () {
          homeKey.currentState?.popUntil(ModalRoute.withName('/qrsmart'));
          Navigator.of(context, rootNavigator: true).pop();
        }, false, false);
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future _openDoors(devSn) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/openDevice/$companyId/$devSn';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }));

      if (response.statusCode == 200) {
        var jsonRes = openDoorsModel.fromJson(response.data);
        if (jsonRes.data!.code == 0) {
          print('DeviceNumber : ${devSn}');
          print('OpenDoor Success');
          print('Status : ${jsonRes.data!.code}');
          CallNativeJava(false, null, null, null);
          setState(() {
            loading = false;
          });
          snackbar(context, Theme.of(context).primaryColor, 'เปิดประตูสำเร็จ',
              Icons.check_circle_outline_rounded);
        } else if (jsonRes.data!.code == 10000) {
          print('DeviceNumber : ${devSn}');
          print('Door Offline');
          print('Status : ${jsonRes.data!.code}');
          setState(() {
            loading = false;
          });
          snackbar(context, Colors.red, 'ประตูออฟไลน์อยู่',
              Icons.highlight_off_rounded);
        } else if (jsonRes.data!.code == 10400) {
          print('DeviceNumber : ${devSn}');
          print('Invalid Device');
          print('Status : ${jsonRes.data!.code}');
          setState(() {
            loading = false;
          });
          snackbar(context, Colors.red, 'หมายเลขอุปกรณ์ไม่ถูกต้อง',
              Icons.highlight_off_rounded);
        }
      } else {
        snackbar(context, Colors.red, 'เปิดประตูไม่สำเร็จ',
            Icons.highlight_off_rounded);
        print('OpenDoor Fail!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.of(context).pop();
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  Future _openDoorsWeigan(DoorId, Num) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/openDoorweigan';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: {
            "door_id": DoorId,
            "door_num": Num,
          });

      if (response.statusCode == 200) {
        await Future.delayed(Duration(milliseconds: 400));
        print('OpenDoor Success');
        print('Status : ${response.data}');
        setState(() {
          loading = false;
        });
        snackbar(context, Theme.of(context).primaryColor, 'เปิดประตูสำเร็จ',
            Icons.check_circle_outline_rounded);
      } else {
        snackbar(context, Colors.red, 'เปิดประตูไม่สำเร็จ',
            Icons.highlight_off_rounded);
        print('OpenDoor Fail!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
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
    getValueShared();
    // _loadStatusAutoDoors();
  }

  void _searchData(String text) {
    setState(() {
      listdet = detlist?.where((item) {
        var date = item.doorName!.toLowerCase();
        return date.contains(text);
      }).toList();
      listDevice = devicelidt.where((item) {
        var date = item.name!.toLowerCase();
        return date.contains(text);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // CallNativeJava(false, null, null, null);
        Navigator.pop(context);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('เปิดประตู'),
              // leading: IconButton(
              //     icon: Platform.isIOS
              //         ? Icon(Icons.arrow_back_ios_new_rounded)
              //         : Icon(Icons.arrow_back),
              //     onPressed: () {
              //       // CallNativeJava(false, null, null, null);
              //       Navigator.pop(context);
              //     }),
            ),
            body: loading
                ? Container()
                : deviceId == null && weiganId == null
                    ? Logo_Opacity(
                        title: 'ไม่มีประตูที่คุณใช้ได้\nโปรดติดต่อผู้ดูแล')
                    : Column(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                              child: Search_From(
                                title: 'ค้นหาประตู',
                                fieldText: fieldText,
                                clear: () {
                                  setState(() {
                                    fieldText.clear();
                                    listdet = detlist;
                                    listDevice = devicelidt;
                                  });
                                },
                                changed: (value) {
                                  _searchData(value);
                                },
                              )),
                          Expanded(
                            child: listDevice.isEmpty && listdet!.isEmpty
                                ? Logo_Opacity(title: 'ไม่พบประตูที่ใช้ได้')
                                : RefreshIndicator(
                                    onRefresh: () async {
                                      getValueShared();
                                    },
                                    child: SingleChildScrollView(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 20, 5),
                                      child: Column(
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: listDevice.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(
                                                          10)),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  elevation: 10,
                                                  child: listDevice[index]
                                                              .connectionStatus ==
                                                          1
                                                      ? doorsButton(
                                                          '${listDevice[index].name}',
                                                          'เปิดประตู',
                                                          Icons
                                                              .meeting_room_rounded,
                                                          Theme.of(context)
                                                              .primaryColor,
                                                          () => _openDoors(
                                                              listDevice[index]
                                                                  .devSn))
                                                      // DoorOnline(
                                                      //     name: listDevice[index].name!,
                                                      //     press: () {
                                                      //       _openDoors(listDevice[index].devSn);
                                                      //     },
                                                      //     devSn: listDevice[index].devSn!,
                                                      //     devMac: listDevice[index].devMac!,
                                                      //     appKey: listDevice[index].appEkey!,
                                                      //     valueDoor:
                                                      //         listDevice[index].screenType!,
                                                      //   )
                                                      : doorsButton(
                                                          '${listDevice[index].name}',
                                                          'ประตูออฟไลน์',
                                                          Icons
                                                              .no_meeting_room_rounded,
                                                          Colors.red,
                                                          () => snackbar(
                                                              context,
                                                              Colors.red,
                                                              'ประตูออฟไลน์อยู่',
                                                              Icons.highlight_off_rounded)));
                                            },
                                          ),
                                          ListView.builder(
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: listdet?.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 5),
                                                  elevation: 5,
                                                  child: doorsButton(
                                                      '${listdet?[index].doorName}',
                                                      'เปิดประตู',
                                                      Icons
                                                          .meeting_room_rounded,
                                                      Theme.of(context)
                                                          .primaryColor,
                                                      () => _openDoorsWeigan(
                                                          listdet?[index]
                                                              .doorId,
                                                          listdet?[index]
                                                              .doorNum)));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
          ),
          loading ? Loading() : Container()
        ],
      ),
    );
  }

  Widget doorsButton(name, button, icon, color, press) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Text(name, style: TextStyle(fontSize: 17)),
      trailing: ElevatedButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          primary: Colors.white,
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
        child: Wrap(
          children: [
            Icon(
              icon,
              size: 30,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              button,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        onPressed: press,
      ),
    );
  }
}
