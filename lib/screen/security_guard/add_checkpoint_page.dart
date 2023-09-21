// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_import

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/models/get_checklist.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Add_CheckPoint extends StatefulWidget {
  final timeCheck;
  final String checkpointId;
  final lat;
  final lng;
  const Add_CheckPoint(
      {Key? key,
      required this.checkpointId,
      required this.lat,
      required this.lng,
      required this.timeCheck});

  @override
  State<Add_CheckPoint> createState() => _Add_CheckPointState();
}

class _Add_CheckPointState extends State<Add_CheckPoint> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController detail = TextEditingController();

  var companyId;
  var userId;
  List<Data> listdata = [];
  List<Checklist> listcheck = [];
  bool loading = false;
  String? checkpointName = null;
  int? verify = 0;
  // var timeCheck = DateTime.now();

  Future _getChecklist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('companyId');
    userId = prefs.getString('userId');
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
                'found_error'.tr,
                'invalid_qrcode'.tr,
                Icons.highlight_off_rounded,
                Colors.red,
                'ok'.tr, () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }, false, false);
          } else if (listdata[0].verify == 1) {
            dialogOnebutton(context, 'checkpoint_regis'.tr,
                Icons.warning_amber_rounded, Colors.orange, 'ok'.tr, () {
              Navigator.popUntil(context, (route) => route.isFirst);
            }, false, false);
          } else {
            checkpointName = listdata[0].checkpointName;
            verify = listdata[0].verify;
          }

          for (int i = 0; i < listdata.length; i++) {
            listcheck.addAll(listdata[i].checklist!);
          }
        }
      } catch (error) {
        print(error);
        await Future.delayed(Duration(milliseconds: 500));
        error_connected(context, () {
          Navigator.popUntil(context, (route) => route.isFirst);
        });
        setState(() {
          loading = false;
        });
      }
    } else {
      dialogOnebutton_Subtitle(
          context,
          'found_error'.tr,
          'invalid_location_again'.tr,
          Icons.highlight_off_rounded,
          Colors.red,
          'ok'.tr, () {
        Navigator.popUntil(context, (route) => route.isFirst);
      }, false, false);
      print('Location Null !!');
    }
  }

  Future _AddcheckPoint(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/created/verifyCheckpoint';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);
      print(values);
      var _response = response.toString().split(',').first.split(':').last;
      if (_response == '200') {
        print('checkIn Success');
        print(values);
        print(response.data);

        dialogOnebutton(context, 'register_success'.tr,
            Icons.check_circle_outline_rounded, Colors.green, 'ok'.tr, () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }, false, false);

        // snackbar(context, Theme.of(context).primaryColor, 'ลงทะเบียนสำเร็จ',
        //     Icons.check_circle_outline_rounded);

        setState(() {
          loading = false;
        });
      } else {
        dialogOnebutton_Subtitle(
            context,
            'found_error'.tr,
            'register_fail_again'.tr,
            Icons.highlight_off_rounded,
            Colors.red,
            'ok'.tr, () {
          Navigator.of(context).pop();
        }, false, false);
        print('checkIn not Success!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      error_connected(context, () {
        Navigator.of(context, rootNavigator: true).pop();
      });

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
    var date = DateFormat('dd-MM-y').format(widget.timeCheck);
    var time = DateFormat('HH:mm:ss').format(widget.timeCheck);

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text('register_point'.tr),
              leading: button_back(() {
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
                loading || checkpointName == null || verify == 1
                    ? Container()
                    : Buttons(
                        title: 'register_title'.tr,
                        press: () {
                          if (_formkey.currentState!.validate()) {
                            Map<String, dynamic> valuse = Map();
                            valuse['id'] = widget.checkpointId;
                            valuse['checkpoint_lat'] = widget.lat;
                            valuse['checkpoint_lng'] = widget.lng;
                            _AddcheckPoint(valuse);
                          }
                        }),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: loading || checkpointName == null || verify == 1
                    ? Container()
                    : Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textIcon(
                                '${'date'.tr} $date ${'time'.tr} $time',
                                color: Colors.red,
                                Icon(
                                  Icons.edit_calendar_rounded,
                                  size: 25,
                                )),
                            SizedBox(height: 10),
                            textIcon(
                                '${'checkpoint'.tr} : $checkpointName',
                                Icon(
                                  Icons.maps_home_work_rounded,
                                  size: 25,
                                )),
                            SizedBox(height: 10),
                            textIcon(
                              'checklist'.tr,
                              Icon(
                                Icons.task_rounded,
                                size: 25,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  // physics: NeverScrollableScrollPhysics(),
                                  itemCount: listcheck.length,
                                  itemBuilder: ((context, index) =>
                                      listcheck[index].checklist == ''
                                          ? Container()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30,
                                                      vertical: 5),
                                              child: Text(
                                                  '- ${listcheck[index].checklist}'),
                                            ))),
                            ),
                            ExpansionTile(
                              tilePadding: EdgeInsets.zero,
                              title: textIcon(
                                'checkpoint_location'.tr,
                                Icon(
                                  Icons.location_on_sharp,
                                  size: 25,
                                  color: Colors.red.shade600,
                                ),
                              ),
                              children: [
                                verify == 1
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
