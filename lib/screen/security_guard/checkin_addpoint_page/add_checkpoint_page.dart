// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, unused_import

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/controller/security_controller/add_checkpoint_controller.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

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
  List<checkPoint> listdata = addCheckpointController.CheckPoint;
  List<CheckpointList> checkList = addCheckpointController.CheckList;
  RxString checkpointName = addCheckpointController.checkpointName;
  RxInt verify = addCheckpointController.verify;
  DateTime dateNow = DateTime.now();

  Future getChecklist() async {
    String checkpointId;
    if (widget.checkpointId.contains('http')) {
      checkpointId = 'error';
      log('idCheck: error');
    } else {
      checkpointId = widget.checkpointId;
    }
    if (widget.lat != null) {
      await addCheckpointController.get_Checklist(
          checkpointId: checkpointId, loadingTime: 1);
    } else {
      dialogOnebutton_Subtitle(
          title: 'occur_error'.tr,
          subtitle: 'invalid_location_again'.tr,
          icon: Icons.highlight_off_rounded,
          colorIcon: Colors.red,
          textButton: 'ok'.tr,
          press: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          click: false,
          backBtn: false,
          willpop: false);
    }
  }

  String createformat(fullDate, String type) {
    if (type == 'D') {
      DateFormat formatDate = DateFormat('dd-MM-y');
      return formatDate.format(DateTime.parse(fullDate));
    } else {
      DateFormat formatTime = DateFormat('HH:mm');
      return formatTime.format(DateTime.parse(fullDate));
    }
  }

  @override
  void initState() {
    super.initState();
    getChecklist();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Obx(
        () => Stack(
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
              floatingActionButton: connectApi.loading.isTrue ||
                      checkpointName == '' ||
                      verify == 1
                  ? Container()
                  : Buttons(
                      title: 'register_title'.tr,
                      press: () {
                        if (_formkey.currentState!.validate()) {
                          Map<String, dynamic> values = Map();
                          values['checkpoint_id'] = widget.checkpointId;
                          values['lat'] = widget.lat;
                          values['lng'] = widget.lng;
                          addCheckpointController.add_Checkpoint(values);
                        } else {
                          form_error_snackbar();
                        }
                      }),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: connectApi.loading.isTrue ||
                          checkpointName == '' ||
                          verify == 1
                      ? Container()
                      : Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Icon(
                                  Icons.edit_calendar_rounded,
                                  color: Theme.of(context).dividerColor,
                                  size: 30,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '${'date'.tr} ${createformat(dateNow.toString(), 'D')} ${'time'.tr}',
                                  style: TextStyle(color: Colors.red),
                                ),
                                DigitalClock(
                                  hourMinuteDigitTextStyle:
                                      const TextStyle(color: Colors.red),
                                  secondDigitTextStyle:
                                      const TextStyle(color: Colors.red),
                                  colon: Text(
                                    ':',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ]),
                              SizedBox(height: 5),
                              textIcon(
                                  '${'checkpoint'.tr} : ${checkpointName}',
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: checkList.length,
                                    itemBuilder: ((context, index) =>
                                        checkList[index].checkpointName == ''
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30,
                                                        vertical: 5),
                                                child: Text(
                                                    '- ${checkList[index].checkpointName}'),
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
                                          myLocation: true,
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
            connectApi.loading.isTrue ? Loading() : Container()
          ],
        ),
      ),
    );
  }
}
