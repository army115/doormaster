// ignore_for_file: prefer_const_constructors

import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/datetime/date_time.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/models/device_group.dart';
import 'package:doormster/models/visitor_model.dart';
import 'package:doormster/screen/visitor_detail_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Visitor_Page extends StatefulWidget {
  Visitor_Page({Key? key}) : super(key: key);

  @override
  State<Visitor_Page> createState() => _Visitor_PageState();
}

class _Visitor_PageState extends State<Visitor_Page> {
  final _kye = GlobalKey<FormState>();
  final visitName = TextEditingController();
  final visitPeople = TextEditingController();
  final phone = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  final useCount = TextEditingController();

  var token;
  var userId;
  var companyId;
  var deviceId;

  List<Device> listDevice = [];
  bool loading = false;

  Future _getDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token');
    userId = prefs.getInt('userId');
    companyId = prefs.getInt('companyId');
    deviceId = prefs.getString('deviceId');

    print('token: ${token}');
    print('userId: ${userId}');
    print('companyId: ${companyId}');
    print('deviceId: ${deviceId}');

    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/getdevicegroupcompanyid/$deviceId';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        DeviceGroup deviceGp =
            DeviceGroup.fromJson(convert.jsonDecode(response.body));
        setState(() {
          listDevice = deviceGp.device!;
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

  Future _craateVisitor(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/createVisitor/$companyId';
      var response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: convert.jsonEncode(values));

      if (response.statusCode == 200) {
        var visitorData;
        var QRcodeData;
        VisitorModel visitormodel =
            VisitorModel.fromJson(convert.jsonDecode(response.body));
        visitorData = [
          visitormodel.visitorName,
          visitormodel.visitorPeople,
          visitormodel.startDate,
          visitormodel.endDate,
          visitormodel.telVisitor,
          visitormodel.usableCount,
        ];
        QRcodeData = [
          visitormodel.qrcode!.tempCode,
          visitormodel.qrcode!.tempPwd,
          visitormodel.qrcode!.qrCode,
        ];

        print('craate Visitor Success');
        print(values);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Visitor_Detail(
                      visitordData: visitorData,
                      QRcodeData: QRcodeData,
                    )));
        setState(() {
          loading = false;
        });
        snackbar(context, Colors.indigo, 'สร้าง QR Code สำเร็จ', Icons.check);
      } else {
        snackbar(context, Colors.red, 'สร้าง QR Code ไม่สำเร็จ', Icons.close);
        print('craate Visitor Fail!!');
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
      alignment: Alignment.center,
      children: [
        Scaffold(
          appBar: AppBar(title: Text('ลงทะเบียนผู้มาติดต่อ')),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            child: Buttons(
                title: 'สร้าง QRCode',
                press: () {
                  if (_kye.currentState!.validate()) {
                    Map<String, dynamic> valuse = Map();
                    valuse['devsns'] = dropdownValue;
                    valuse['usableCount'] = useCount.text;
                    valuse['startDate'] = startDate.text;
                    valuse['endDate'] = endDate.text;
                    valuse['visitor_name'] = visitName.text;
                    valuse['tel_visitor'] = phone.text;
                    valuse['visipeople'] = visitPeople.text;
                    valuse['created_by'] = userId;
                    _craateVisitor(valuse);
                    print(valuse);
                  }
                }),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _kye,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ชื่อผู้มาติดต่อ'),
                            Text_Form(
                                controller: visitName,
                                title: 'ชื่อ - สกุล',
                                icon: Icons.person,
                                error: 'กรุณากรอกชื่อผู้ใช้'),
                            Text('ติดต่อพบ'),
                            Text_Form(
                                controller: visitPeople,
                                title: 'ชื่อ - สกุล',
                                icon: Icons.person_outline,
                                error: 'กรุณากรอกชื่อผู้ใช้'),
                            Text('เบอร์ติดต่อ'),
                            Text_Form(
                                controller: phone,
                                title: 'เบอร์โทร',
                                icon: Icons.phone,
                                error: 'กรุณากรอกชื่อผู้ใช้'),
                            Text('สิทธ์การเข้าถึง'),
                            DropDownSn(),
                            Text('เริ่มต้น'),
                            StertDate(),
                            Text('สิ้นสุด'),
                            EndDate(),
                            Text('สิทธิ์การใช้งาน'),
                            Text_Form(
                                controller: useCount,
                                title: 'จำนวนครั้ง',
                                icon: Icons.add_circle_outline_sharp,
                                error: 'กรุณากรอกชื่อผู้ใช้'),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
        loading ? Loading() : Container()
      ],
    );
  }

  var dropdownValue;
  Widget DropDownSn() {
    return Dropdown(
        title: deviceId == null ? 'ไม่มีอุปกรณ์' : 'เลือกอุปกรณ์',
        values: dropdownValue,
        listItem: listDevice.map((value) {
          return DropdownMenuItem(
            value: value.devicegroupDevice,
            child: Text('${value.devicegroupName}'),
          );
        }).toList(),
        leftIcon: Icon(Icons.mobile_friendly),
        rightIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        validate: (values) {
          if (deviceId != null) {
            if (values == null) {
              return 'เลือกอุปกรณ์';
            }
            return null;
          }
          return 'ไม่มีอุปกรณ์';
        },
        onChange: (value) {
          setState(() {
            dropdownValue = value!;
            print(value);
          });
        });
  }

  Widget StertDate() {
    return Date_time(
        controller: startDate,
        title: 'เลือกวันที่',
        leftIcon: Icon(Icons.event_note_rounded),
        rightIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        theme: DatePickerTheme(
          titleHeight: 50,
          headerColor: Colors.indigo,
          cancelStyle: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          doneStyle: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          backgroundColor: Colors.grey.shade200,
          itemHeight: 45,
          itemStyle: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.normal),
          containerHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        language: LocaleType.th,
        onConfirm: (date) {
          String datetime = DateFormat('y-M-d HH:mm:ss').format(date);
          setState(() {
            startDate.text = datetime;
          });
          print(datetime);
        },
        error: 'กรุณาเลือกวันที่');
  }

  Widget EndDate() {
    return Date_time(
        controller: endDate,
        title: 'เลือกวันที่',
        leftIcon: Icon(Icons.event_note_rounded),
        rightIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
        theme: DatePickerTheme(
          titleHeight: 50,
          headerColor: Colors.indigo,
          cancelStyle: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          doneStyle: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          backgroundColor: Colors.grey.shade200,
          itemHeight: 45,
          itemStyle: TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.normal),
          containerHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        language: LocaleType.th,
        onConfirm: (date) {
          String datetime = DateFormat('y-M-d HH:mm:ss').format(date);
          setState(() {
            endDate.text = datetime;
          });
          print(datetime);
        },
        error: 'กรุณาเลือกวันที่');
  }
}
