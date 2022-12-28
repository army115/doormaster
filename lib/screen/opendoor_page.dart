import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/device_group.dart';
import 'package:doormster/models/doors_device.dart';
import 'package:doormster/models/opendoors_model.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool light = false;

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
      snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
          Icons.warning_amber_rounded);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDevice();
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
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: ListView.builder(
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
                              : doorsOOFline('${listDevice[index].name}'));
                    },
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
            style: TextStyle(fontSize: 20, color: Colors.black)),
        switchs(),
      ]),
    );
  }

  Widget doorsOOFline(name) {
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
        value: light,
        activeColor: Theme.of(context).primaryColor,
        onChanged: (value) {
          setState(() {
            light = value;
          });
        },
      ),
    );
  }
}
