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

  Future _deviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');
    companyId = prefs.getInt('companyId');
    deviceId = prefs.getString('deviceId');

    print('token: ${token}');
    print('companyId: ${companyId}');
    print('deviceId: ${deviceId}');
  }

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

  void _loadStatusAutoDoors() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var DoorAuto = prefs.getBool("autoDoor") ?? false;
      print('autoDoor : $DoorAuto');
      if (DoorAuto) {
        setState(() {
          autoDoor = true;
          _CallJavaSDK();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    // _deviceId();
    // if (deviceId != null) {
    _getDevice();
    // } else {}
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
                                    ? doorsONline('${listDevice[index].name}',
                                        () {
                                        _openDoors(listDevice[index].devSn);
                                      }, listDevice[index].devSn)
                                    : doorsOFFline(
                                        '${listDevice[index].name}'));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }

  Widget doorsONline(name, press, devSn) {
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
        switchs(devSn),
      ]),
    );
  }

  Widget doorsOFFline(name) {
    return ListTile(
      minVerticalPadding: 15,
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

  Widget switchs(devSn) {
    return Transform.scale(
      scale: 1.5,
      child: Switch(
        value: autoDoor,
        activeColor: Theme.of(context).primaryColor,
        onChanged: (bool value) {
          _ShareValue(value);
          return DevSn = devSn;
        },
      ),
    );
  }

  bool autoDoor = false;
  Future _ShareValue(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("autoDoor", value!);

    setState(() {
      autoDoor = value;
      _CallJavaSDK();
      print('autoDoor : $autoDoor');
      print('DevSn : $DevSn');
    });
  }

  String DevSn = '';
  Future _CallJavaSDK() async {
    MethodChannel platform = MethodChannel('samples.flutter.dev/autoDoor');
    try {
      final result = await platform.invokeMethod('openAutoDoor', {
        "value": autoDoor,
        "devSn": DevSn,
        "devMac": "34:b4:72:f9:b5:76",
        "appEkey":
            "66ca8bc357538b796a66227cb16c8c6e000000000000000000000011111111111000"
      });
      print("ส่งค่า $result");
    } on PlatformException catch (e) {
      '${e.message}';
    }
  }
}
