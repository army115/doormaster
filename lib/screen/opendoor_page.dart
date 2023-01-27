import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/doors_device.dart';
import 'package:doormster/models/opendoors_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class Opendoor_Page extends StatefulWidget {
  Opendoor_Page({Key? key}) : super(key: key);

  @override
  State<Opendoor_Page> createState() => _Opendoor_PageState();
}

class _Opendoor_PageState extends State<Opendoor_Page> {
  var token;
  var companyId;
  var deviceId;

  List<Lists> listDevice = [];
  bool loading = false;

  Future _getDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');
    companyId = prefs.getString('companyId');
    deviceId = prefs.getString('deviceId');

    print('token: ${token}');
    print('companyId: ${companyId}');
    print('deviceId: ${deviceId}');

    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/getdeviceuuidmobile/$deviceId';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        DoorsDeviece deviceDoors =
            DoorsDeviece.fromJson(convert.jsonDecode(response.body));
        setState(() {
          listDevice = deviceDoors.lists!;
          loading = false;
        });
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
          'ตกลง',
          () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        );
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
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonRes =
            openDoorsModel.fromJson(convert.jsonDecode(response.body));
        if (jsonRes.data!.code == 0) {
          var visitorData;
          var QRcodeData;

          print('DeviceNumber : ${devSn}');
          print('OpenDoor Success');
          print('Status : ${jsonRes.data!.code}');
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
        print(response.body);
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
        'ตกลง',
        () {
          Navigator.of(context).pop();
        },
      );
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDevice();
    // _loadStatusAutoDoors();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('เปิดประตู'),
          ),
          body: deviceId == null
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
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  shrinkWrap: true,
                  itemCount: listDevice.length,
                  itemBuilder: (context, index) {
                    return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        elevation: 5,
                        child: listDevice[index].connectionStatus == 1
                            ? DoorOnline(
                                name: listDevice[index].name!,
                                press: () {
                                  _openDoors(listDevice[index].devSn);
                                },
                                devSn: listDevice[index].devSn!,
                                devMac: listDevice[index].devMac!,
                                appKey: listDevice[index].appEkey!,
                                valueDoor: listDevice[index].screenType!,
                              )
                            : doorsOFFline('${listDevice[index].name}'));
                  },
                ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }

  Widget doorsOFFline(name) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Text(name, style: TextStyle(fontSize: 20)),
      trailing: ElevatedButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          primary: Colors.white,
          backgroundColor: Colors.redAccent,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
        child: Wrap(
          children: [
            Icon(
              Icons.no_meeting_room_rounded,
              size: 30,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              'ประตูออฟไลน์',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
        onPressed: () async {
          snackbar(context, Colors.red, 'ประตูออฟไลน์อยู่',
              Icons.highlight_off_rounded);
        },
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

  Future _CallJavaSDK(value) async {
    MethodChannel platform = MethodChannel('samples.flutter.dev/autoDoor');
    try {
      final result = await platform.invokeMethod('openAutoDoor', {
        "value": value,
        "devSn": widget.devSn,
        "devMac": widget.devMac,
        "appEkey": widget.appKey
      });
      print("ส่งค่า $result");
    } on PlatformException catch (e) {
      '${e.message}';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadStatusAutoDoors();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool("autoDoor", value);
                _CallJavaSDK(value);
                setState(() {
                  widget.valueDoor = value;
                  print("autoDoor : $value");
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
