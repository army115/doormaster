// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/datetime/date_time.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_number.dart';
import 'package:doormster/models/device_group.dart';
import 'package:doormster/models/visitor_model.dart';
import 'package:doormster/screen/qr_smart_access/visitor_detail_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import 'dart:async';
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

  var userId;
  var companyId;
  var deviceId;

  List<DataDrvices> listDevice = [];
  bool loading = false;

  Future _getDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    companyId = prefs.getString('companyId');
    deviceId = prefs.getString('deviceId');

    print('userId: ${userId}');
    print('companyId: ${companyId}');
    print('deviceId: ${deviceId}');

    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/getdevicegroup_uuid/$deviceId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200) {
        DeviceGroup deviceGp = DeviceGroup.fromJson(response.data);
        setState(() {
          listDevice = deviceGp.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(context, 'พบข้อผิดพลาด', 'ไม่สามารถเชื่อมต่อได้',
          Icons.warning_amber_rounded, Colors.orange, 'ตกลง', () {
        Navigator.popUntil(context, (route) => route.isFirst);
      }, false, false);
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
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);

      if (response.statusCode == 200) {
        var visitorData;
        var QRcodeData;
        VisitorModel visitormodel = VisitorModel.fromJson(response.data);
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
        snackbar(context, Theme.of(context).primaryColor,
            'สร้าง QR Code สำเร็จ', Icons.check_circle_outline_rounded);
      } else {
        snackbar(context, Colors.red, 'สร้าง QR Code ไม่สำเร็จ',
            Icons.highlight_off_rounded);
        print('craate Visitor Fail!!');
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
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
                              error: 'กรุณากรอกชื่อผู้มาติดต่อ',
                              TypeInput: TextInputType.name,
                            ),
                            Text('ติดต่อพบ'),
                            Text_Form(
                              controller: visitPeople,
                              title: 'ชื่อ - สกุล',
                              icon: Icons.person_outline,
                              error: 'กรุณากรอกชื่อผู้ที่ติดต่อพบ',
                              TypeInput: TextInputType.name,
                            ),
                            Text('เบอร์ติดต่อ'),
                            TextForm_Number(
                              controller: phone,
                              title: 'เบอร์โทร',
                              icon: Icons.phone,
                              type: TextInputType.phone,
                              maxLength: 10,
                              error: (values) {
                                if (values.isEmpty) {
                                  return 'กรุณากรอกเบอร์โทร';
                                  // } else if (values.length < 10) {
                                  //   return "กรุณากรอกเบอร์โทรให้ครบ 10 ตัว";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Text('สิทธ์การเข้าถึง'),
                            DropDownSn(),
                            Text('เริ่มต้น'),
                            Date_time(
                                controller: startDate,
                                title: 'เลือกวันที่',
                                leftIcon: Icons.event_note_rounded,
                                error: 'กรุณาเลือกวันที่'),
                            Text('สิ้นสุด'),
                            Date_time(
                                controller: endDate,
                                title: 'เลือกวันที่',
                                leftIcon: Icons.event_note_rounded,
                                error: 'กรุณาเลือกวันที่'),
                            Text('สิทธิ์การใช้งาน'),
                            TextForm_Number(
                              controller: useCount,
                              title: 'จำนวนครั้ง',
                              icon: Icons.add_circle_outline_sharp,
                              type: TextInputType.number,
                              maxLength: 2,
                              error: (values) {
                                if (values.isEmpty) {
                                  return 'กรุณาเพิ่มสิทธิ์การใช้งาน';
                                } else {
                                  return null;
                                }
                              },
                            ),
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
      title: deviceId == null || listDevice.length == 0
          ? 'ไม่มีอุปกรณ์'
          : 'เลือกอุปกรณ์',
      values: dropdownValue,
      listItem: listDevice.map((value) {
        return DropdownMenuItem(
          value: value.deviceDevSn,
          child: Text(
            '${value.deviceName}',
          ),
        );
      }).toList(),
      leftIcon: Icons.mobile_friendly,
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
          dropdownValue = value;
          print('DeviceNumber : ${value}');
        });
      },
    );
  }
}
