import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/doors_device.dart';
import 'package:doormster/models/opendoors_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scan_bluetooth/flutter_scan_bluetooth.dart';
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
    companyId = prefs.getInt('companyId');
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

  void _loadStatusAutoDoors() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var DoorAuto = prefs.getBool("autoDoor") ?? false;
      print('autoDoor : $DoorAuto');
      if (DoorAuto) {
        setState(() {
          autoDoor = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getDevice();
    _loadStatusAutoDoors();

    // _bluetooth.devices.listen((device) {
    //   setState(() {
    //     _data += device.name + ' (${device.address})\n';
    //   });
    // });
    // _bluetooth.scanStopped.listen((device) {
    //   setState(() {
    //     autoDoor = false;
    //     _data += 'scan stopped\n';
    //   });
    // });
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
                        'ไม่มีประตูที่คุณใช้ได้',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: listDevice.length,
                          itemBuilder: (context, index) {
                            return Card(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                elevation: 5,
                                child: listDevice[index].connectionStatus == 1
                                    ? doorsONline(
                                        '${listDevice[index].name}',
                                        () {
                                          _openDoors(listDevice[index].devSn);
                                        },
                                      )
                                    : doorsOFFline(
                                        '${listDevice[index].name}'));
                          },
                        ),
                        // ListView(
                        //   shrinkWrap: true,
                        //   children: [
                        Text(_data),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }

  Widget doorsONline(name, press) {
    return ListTile(
      minVerticalPadding: 15,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: TextStyle(
                fontSize: 20,
              )),
          ElevatedButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                elevation: 5,
              ),
              child: Wrap(
                children: [
                  Icon(
                    Icons.meeting_room_rounded,
                    size: 30,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    'เปิดประตู',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              onPressed: press)
        ],
      ),
      subtitle:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('เปิดประตูอัตโนมัติ',
            style: TextStyle(
                fontSize: 20,
                color: autoDoor == false
                    ? Colors.grey
                    : Theme.of(context).primaryColor)),
        switchs(),
      ]),
    );
  }

  Widget doorsOFFline(name) {
    return ListTile(
      minVerticalPadding: 15,
      title: Text(name, style: TextStyle(fontSize: 20)),
      trailing: ElevatedButton(
        style: TextButton.styleFrom(
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
        onPressed: () {
          snackbar(context, Colors.red, 'ประตูออฟไลน์อยู่',
              Icons.highlight_off_rounded);
        },
      ),
    );
  }

  Widget switchs() {
    return Transform.scale(
      scale: 1.5,
      child: Switch(
          value: autoDoor,
          activeColor: Theme.of(context).primaryColor,
          onChanged: _AutoDoors),
    );
  }

  bool autoDoor = false;
  void _AutoDoors(bool? value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("autoDoor", value!);
    try {
      if (autoDoor) {
        // await _bluetooth.stopScan();
        // debugPrint("scanning stoped");
        setState(() {
          _data = '';
          autoDoor = value;
        });
      } else {
        // await _bluetooth.startScan(pairedDevices: false);
        // debugPrint("scanning started");
        setState(() {
          autoDoor = value;
        });
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    // setState(() {
    //   autoDoor = value;
    //   print('autoDoor : $autoDoor');
    // });
  }

  FlutterScanBluetooth _bluetooth = FlutterScanBluetooth();
  String _data = '';
}
