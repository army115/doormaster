import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/doors_device.dart';
import 'package:doormster/models/getdoor_weigan.dart';
import 'package:doormster/models/opendoors_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:doormster/service/connect_native.dart';
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

  List<Lists> listDevice = [];
  List<DataWeigan> listWeigan = [];
  List<Det>? listdet = [];
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
    // _getDoorWeigan();
  }

  Future _getDoorDevice() async {
    try {
      setState(() {
        loading = true;
      });

      //call api device
      var url = '${Connect_api().domain}/getdeviceuuidmobile/$deviceId';
      var res = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

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

      if (res.statusCode == 200 && response.statusCode == 200) {
        DoorsDeviece deviceDoors = DoorsDeviece.fromJson(res.data);

        getDoorWeigan doorsWeigan = getDoorWeigan.fromJson(response.data);
        setState(() {
          listDevice = deviceDoors.lists!;
          listWeigan = doorsWeigan.data!;
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
          Navigator.popUntil(context, (route) => route.isFirst);
        }, false, false);
      }
      setState(() {
        loading = false;
      });
    }
  }

  // Future _getDoorDevice() async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });

  //     //call api device
  //     var url = '${Connect_api().domain}/getdeviceuuidmobile/$deviceId';
  //     var res = await Dio().get(
  //       url,
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       }),
  //     );

  //     if (res.statusCode == 200) {
  //       DoorsDeviece deviceDoors = DoorsDeviece.fromJson(res.data);

  //       setState(() {
  //         listDevice = deviceDoors.lists!;
  //         loading = false;
  //       });
  //     }
  //   } catch (error) {
  //     print(error);

  //     dialogOnebutton_Subtitle(
  //         context,
  //         'พบข้อผิดพลาด',
  //         'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
  //         Icons.warning_amber_rounded,
  //         Colors.orange,
  //         'ตกลง', () {
  //       Navigator.popUntil(context, (route) => route.isFirst);
  //     }, false, false);

  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  Future _getDoorWeigan() async {
    try {
      setState(() {
        loading = true;
      });

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
        getDoorWeigan DoorsWeigan = getDoorWeigan.fromJson(response.data);
        setState(() {
          listWeigan = DoorsWeigan.data!;
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
          var visitorData;
          var QRcodeData;

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
        Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        CallNativeJava(false, null, null, null);
        Navigator.pop(context);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('เปิดประตู'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    CallNativeJava(false, null, null, null);
                    Navigator.pop(context);
                  }),
            ),
            body: loading
                ? Container()
                : deviceId == null && weiganId == null ||
                        listDevice.isEmpty && listdet!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ไม่มีประตูที่คุณใช้ได้\nโปรดติดต่อผู้ดูแล',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.normal),
                            ),
                            Image.asset(
                              'assets/images/Smart Community Logo.png',
                              scale: 4.5,
                              // opacity: AlwaysStoppedAnimation(0.7),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: listDevice.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      elevation: 5,
                                      child: listDevice[index]
                                                  .connectionStatus ==
                                              1
                                          ? doorsButton(
                                              '${listDevice[index].name}',
                                              'เปิดประตู',
                                              Icons.meeting_room_rounded,
                                              Theme.of(context).primaryColor,
                                              () => _openDoors(
                                                  listDevice[index].devSn))
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
                                              Icons.no_meeting_room_rounded,
                                              Colors.red,
                                              () => snackbar(
                                                  context,
                                                  Colors.red,
                                                  'ประตูออฟไลน์อยู่',
                                                  Icons
                                                      .highlight_off_rounded)));
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
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      elevation: 5,
                                      child: doorsButton(
                                          '${listdet?[index].doorName}',
                                          'เปิดประตู',
                                          Icons.meeting_room_rounded,
                                          Theme.of(context).primaryColor,
                                          () => _openDoorsWeigan(
                                              listdet?[index].doorId,
                                              listdet?[index].doorNum)));
                                },
                              ),
                            ],
                          ),
                        ),
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
      title: Text(name, style: TextStyle(fontSize: 20)),
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
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        onPressed: press,
      ),
    );
  }
}

class DoorOnline extends StatefulWidget {
  String name;
  final press;
  String devSn;
  String devMac;
  String appKey;
  bool valueDoor;
  DoorOnline(
      {Key? key,
      required this.name,
      required this.press,
      required this.devSn,
      required this.valueDoor,
      required this.devMac,
      required this.appKey});

  @override
  State<DoorOnline> createState() => _DoorOnlineState();
}

class _DoorOnlineState extends State<DoorOnline> {
  void _loadStatusAutoDoors() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var DoorAuto = prefs.getBool("autoDoor") ?? false;
      print('autoDoor : $DoorAuto');
      if (DoorAuto) {
        setState(() {
          widget.valueDoor = true;
          // _CallJavaSDK(widget.valueDoor);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkLocationStatus(value) async {
    LocationPermission permission = await Geolocator.checkPermission();
    try {
      if (value == true) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      }
      await CallNativeJava(value, widget.devSn, widget.devMac, widget.appKey);
      setState(() {
        widget.valueDoor = value;
        print("autoDoor : $value");
      });

      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.setBool("autoDoor", value);

    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    // _loadStatusAutoDoors();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.fromLTRB(10, 5, 10, 0),
          title: Text(widget.name,
              style: TextStyle(
                fontSize: 20,
              )),
          trailing: ElevatedButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 5,
              ),
              child: Wrap(
                children: [
                  Icon(
                    Icons.meeting_room_rounded,
                    size: 30,
                  ),
                  Text(
                    'เปิดประตู',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              onPressed: widget.press),
        ),
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Row(
            children: [
              widget.valueDoor
                  ? Icon(Icons.meeting_room_rounded,
                      size: 30, color: Theme.of(context).primaryColor)
                  : Icon(
                      Icons.door_front_door,
                      size: 30,
                      color: Colors.grey,
                    ),
              Text('เปิดประตูอัตโนมัติ',
                  style: TextStyle(
                      fontSize: 20,
                      color: widget.valueDoor == false
                          ? Colors.grey
                          : Theme.of(context).primaryColor)),
            ],
          ),
          trailing: Transform.scale(
            scale: 1.5,
            child: Switch(
              value: widget.valueDoor,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (bool value) async {
                checkLocationStatus(value);
              },
            ),
          ),
        ),
      ],
    );
  }
}
