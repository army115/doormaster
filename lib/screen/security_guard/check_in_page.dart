// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/checkBox/checkbox_formfield.dart';
import 'package:doormster/components/dropdown/dropdown_noborder.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form_noborder_validator.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/screen/security_guard/report_logs_page.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class Check_In extends StatefulWidget {
  DateTime timeCheck;
  final String checkpointId;
  final lat;
  final lng;
  final roundId;
  final roundName;
  final roundStart;
  final roundEnd;
  Check_In(
      {Key? key,
      required this.checkpointId,
      required this.lat,
      required this.lng,
      required this.timeCheck,
      this.roundId,
      this.roundName,
      this.roundStart,
      this.roundEnd});

  @override
  State<Check_In> createState() => _Check_InState();
}

class _Check_InState extends State<Check_In> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController detail = TextEditingController();
  TextEditingController status = TextEditingController();

  final ImagePicker imgpicker = ImagePicker();
  // List<XFile>? listImage = [];
  List<String>? listImage64 = [];

  selectedImages(ImageSource TypeImage) async {
    try {
      // var pickedfiles = await imgpicker.pickMultiImage();
      final XFile? pickedImages = await imgpicker.pickImage(
          source: TypeImage, maxHeight: 1080, maxWidth: 1080);
      if (pickedImages != null) {
        List<int> imageBytes = await pickedImages.readAsBytes();
        var ImagesBase64 = convert.base64Encode(imageBytes);
        setState(() {
          // listImage?.add(pickedImages);
          listImage64?.add("data:image/png;base64,$ImagesBase64");
          print('image64: $ImagesBase64');
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }

  var companyId;
  var userId;
  // var roundId;
  List<Data> listdata = [];
  List<Checklist> listcheck = [];
  bool loading = false;
  String? checkpointName = null;
  int? verify = 1;

  Future _getChecklist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    userId = prefs.getString('userId');
    // roundId = prefs.getString('roundId');
    print('companyId: $companyId');
    print('userId: $userId');
    print('timeCheck: ${widget.timeCheck}');
    print('lat: ${widget.lat}');
    print('lng: ${widget.lng}');

    String checkpointId;
    print('idCheck: ${widget.checkpointId}');

    if (widget.checkpointId.contains('http')) {
      checkpointId = 'error';
      log('idCheck: error');
    } else {
      checkpointId = widget.checkpointId;
    }

    if (widget.lat != null) {
      try {
        setState(() {
          loading = true;
        });

        //call api
        var url = '${Connect_api().domain}/get/checkpointdetail/$checkpointId';
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

          if (listdata.isEmpty) {
            dialogOnebutton_Subtitle(
                context,
                'พบข้อผิดพลาด',
                'QR Code ไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง',
                Icons.warning_amber_rounded,
                Colors.orange,
                'ตกลง', () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }, false, false);
          } else if (listdata[0].verify == 0) {
            dialogOnebutton_Subtitle(
                context,
                'ไม่พบจุดตรวจ',
                'จุดตรวจนี้ ยังไม่ได้ลงทะเบียน',
                Icons.warning_amber_rounded,
                Colors.orange,
                'ตกลง', () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }, false, false);
          } else {
            checkpointName = listdata[0].checkpointName;
            verify = listdata[0].verify;
          }

          //loop add list []
          for (int i = 0; i < listdata.length; i++) {
            listcheck.addAll(listdata[i].checklist!);
          }
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
          Navigator.popUntil(context, (route) => route.isFirst);
        }, false, false);
        setState(() {
          loading = false;
        });
      }
    } else {
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ตำแหน่งไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง',
          Icons.highlight_off_rounded,
          Colors.red,
          'ตกลง', () {
        Navigator.popUntil(context, (route) => route.isFirst);
      }, false, false);
      print('Location Null !!');
    }
  }

  Future _checkIn(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/created/checkin';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);
      var _response = response.toString().split(',').first.split(':').last;
      if (_response == '200') {
        print('checkIn Success');
        print(values);
        print(response.data);

        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Report_Logs(),
          ),
        );
        // Navigator.popUntil(context, (route) => route.isFirst);
        snackbar(context, Theme.of(context).primaryColor, 'ตรวจเช็คสำเร็จ',
            Icons.check_circle_outline_rounded);

        setState(() {
          loading = false;
        });
      } else {
        dialogOnebutton_Subtitle(
            context,
            'ตำแหน่งไม่ถูกต้อง',
            'ตำแหน่งปัจจุบันไม่ตรงจุดตรวจ กรุณาลองใหม่อีกครั้ง',
            Icons.highlight_off_rounded,
            Colors.red,
            'ตกลง', () {
          Navigator.popUntil(context, (route) => route.isFirst);
        }, false, false);
        print('checkIn not Success!!');
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
      // snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
      //     Icons.warning_amber_rounded);
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getChecklist();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('y-MM-dd').format(widget.timeCheck);
    String time = DateFormat('HH:mm:ss').format(widget.timeCheck);
    // String dateTime =
    //     DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(widget.timeCheck);
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('เช็คจุดตรวจ'),
              leading: button_back(() {
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: loading ||
                    checkpointName == null ||
                    verify == 0
                ? Container()
                : Buttons(
                    title: 'บันทึก',
                    press: () {
                      if (_formkey.currentState!.validate()) {
                        Map<String, dynamic> valuse = Map();
                        // valuse['time'] = '${DateTime.now()}';
                        valuse['time'] =
                            widget.timeCheck.add(Duration(hours: 7)).toString();
                        // .toUtc() //todo ค่าเวลากลาง Utc + 0 ได้ค่ามี Z ต่อท้ายเวลา 2023-03-15 14:05:58.075406Z
                        //todo time zone + 7 ชม.
                        // .toIso8601String(); //todo ได้ค่ามี T ท้ายวันที่ 2023-03-15T14:45:36.325350
                        valuse['lat'] = widget.lat;
                        valuse['lng'] = widget.lng;
                        valuse['EmpID'] = userId;
                        valuse['id'] = companyId;
                        valuse['uuid'] = widget.checkpointId;
                        valuse['Round_uuid'] = widget.roundId;
                        valuse['Desciption'] = detail.text;
                        valuse['EventCheck'] = status.text;
                        valuse['pic'] = listImage64;
                        print(valuse);
                        _checkIn(valuse);
                      }
                    }),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: loading || checkpointName == null || verify == 0
                    ? Container()
                    : Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.edit_calendar_rounded, size: 25),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    'วันที่ $date เวลา $time',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.calendar_month_rounded, size: 25),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text('รอบเดิน : ${widget.roundName}'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.access_time_rounded, size: 25),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                      'ช่วงเวลา : ${widget.roundStart} น. ถึง ${widget.roundEnd} น.'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.maps_home_work_rounded, size: 25),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text('จุดตรวจ : $checkpointName'),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.task_rounded, size: 25),
                                SizedBox(width: 5),
                                Text('รายการตรวจ'),
                              ],
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                // physics: NeverScrollableScrollPhysics(),
                                itemCount: listcheck.length,
                                itemBuilder: ((context, index) =>
                                    listcheck[index].checklist == ''
                                        ? Container()
                                        : CheckBox_FormField(
                                            title:
                                                '${listcheck[index].checklist}',
                                            value: false,
                                            validator: 'กรุณาเลือกรายการ',
                                          ))),
                            Row(
                              children: [
                                Icon(Icons.camera_alt_rounded, size: 25),
                                SizedBox(width: 5),
                                Text('รูปภาพประกอบ'),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ListView(
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    listImage64?.length == 4
                                        ? Container()
                                        : Card(
                                            elevation: 5,
                                            child: InkWell(
                                                onTap: () {
                                                  permissionCamere(
                                                      context,
                                                      () => selectedImages(
                                                          ImageSource.camera));
                                                },
                                                child: Container(
                                                  width: 200,
                                                  height: 200,
                                                  child: const Icon(
                                                    Icons.add_a_photo,
                                                    size: 60,
                                                  ),
                                                )),
                                          ),
                                    listImage64 != null
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            reverse: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: listImage64!.length,
                                            itemBuilder: ((context, index) {
                                              final _Images =
                                                  convert.base64Decode(
                                                      ('${listImage64![index]}')
                                                          .split(',')
                                                          .last);
                                              return Card(
                                                elevation: 5,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    const CircularProgressIndicator(),
                                                    Container(
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image:
                                                                // FileImage(File(
                                                                //     '${listImage![index].path}'))
                                                                MemoryImage(
                                                                    _Images)),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: CircleAvatar(
                                                        radius: 13,
                                                        backgroundColor:
                                                            Colors.red,
                                                        child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          constraints:
                                                              BoxConstraints(),
                                                          splashRadius: 10,
                                                          icon:
                                                              Icon(Icons.close),
                                                          onPressed: () {
                                                            setState(() {
                                                              // listImage?.remove(
                                                              //     listImage![
                                                              //         index]);
                                                              listImage64?.remove(
                                                                  listImage64![
                                                                      index]);
                                                              print(
                                                                  'Image :  $index');
                                                            });
                                                          },
                                                          iconSize: 18,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            }))
                                        : Container(),
                                  ]),
                            ),
                            Row(
                              children: [
                                Icon(Icons.assignment_rounded, size: 25),
                                SizedBox(width: 5),
                                Text('บันทึกเหตุการณ์'),
                              ],
                            ),
                            Dropdown_NoBorder(
                              title: 'เลือกสถานการณ์',
                              controller: status,
                              leftIcon: Icons.mobile_friendly,
                              error: 'กรุณากเลือกบริษัท',
                              listItem: ['ปกติ', 'ไม่ปกติ'],
                            ),
                            TextForm_NoBorder_Validator(
                              typeInput: TextInputType.text,
                              controller: detail,
                              icon: Icons.description_rounded,
                              title: 'รายละเอียด',
                              validator: (values) {
                                if (status.text == 'ไม่ปกติ' &&
                                    values.isEmpty) {
                                  return 'เหตุการณ์ไม่ปกติ กรุณาเพิ่มรายละเอียด';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_sharp,
                                    size: 30,
                                    color: Colors.red.shade600,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'ตำแหน่งจุดตรวจ',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                              children: [
                                verify == 0
                                    ? Container()
                                    : Map_Page(
                                        lat: widget.lat,
                                        lng: widget.lng,
                                        width: double.infinity,
                                        height: 300,
                                      )
                              ],
                            ),
                          ],
                        )),
              ),
            )),
          ),
          loading ? Loading() : Container()
        ],
      ),
    );
  }
}
