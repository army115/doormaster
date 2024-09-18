// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/checkBox/checkbox_formfield.dart';
import 'package:doormster/components/dropdown/dropdown_noborder.dart';
import 'package:doormster/components/image/add_iamges.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/components/text_form/text_form_noborder_validator.dart';
import 'package:doormster/controller/add_images_controller.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/controller/security_controller/check_in_controller.dart';
import 'package:doormster/models/secarity_models/get_checkpoint.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class Check_In extends StatefulWidget {
  final title;
  final String checkpointId;
  final lat;
  final lng;
  final roundId;
  final roundName;
  final roundStart;
  final roundEnd;
  const Check_In(
      {Key? key,
      required this.checkpointId,
      required this.lat,
      required this.lng,
      this.roundId,
      this.roundName,
      this.roundStart,
      this.roundEnd,
      this.title});

  @override
  State<Check_In> createState() => _Check_InState();
}

class _Check_InState extends State<Check_In> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController detail = TextEditingController();
  final listImage = addImagesController.listImage;
  String branchId = branchController.branch_Id.value;

  List<checkPoint> listdata = checkInController.CheckPoint;
  List<CheckpointList> checkList = checkInController.CheckList;

  RxString checkpointName = checkInController.checkpointName;
  RxInt verify = checkInController.verify;

  DateTime dateNow = DateTime.now();
  String? dropdownValue;
  List<Map<String, String>> listEvent = [
    {'value': 'normal', 'label': 'normal'.tr},
    {'value': 'abnormal', 'label': 'abnormal'.tr}
  ];

  Future getChecklist() async {
    String checkpointId;
    if (widget.checkpointId.contains('http')) {
      checkpointId = 'error';
      log('idCheck: error');
    } else {
      checkpointId = widget.checkpointId;
    }
    if (widget.lat != null) {
      await checkInController.get_Checklist(
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
    listImage.clear();
  }

  @override
  void dispose() {
    listImage.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Obx(() {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                leading: button_back(() {
                  Navigator.popUntil(context, (route) => route.isFirst);
                }),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: connectApi.loading.isTrue ||
                      checkpointName == '' ||
                      verify == 0
                  ? Container()
                  : Buttons(
                      title: 'save'.tr,
                      press: () async {
                        List<String?> listcheckId = checkList
                            .map((checkpoint) => checkpoint.checkpointListId)
                            .toList();

                        List<dio.MultipartFile> files = [];
                        for (int i = 0; i < listImage.length; i++) {
                          files.add(await dio.MultipartFile.fromFile(
                            listImage[i].path,
                            filename: listImage[i].name,
                          ));
                        }

                        if (_formkey.currentState!.validate()) {
                          Map<String, dynamic> values = {};
                          values['branch_id'] = branchId;
                          values['inspect_id'] = widget.roundId ?? '';
                          values['checkpoint_id'] = widget.checkpointId;
                          values['checkpoint_list_id'] =
                              jsonEncode(listcheckId);
                          values['lat'] = widget.lat;
                          values['lng'] = widget.lng;
                          values['status'] = dropdownValue;
                          values['event'] = dropdownValue;
                          values['description'] = detail.text;
                          values['is_outside_cycle'] =
                              widget.roundId != null ? "0" : "1";
                          values['is_outside_checkpoint'] = "0";
                          values['files'] = files;
                          checkInController.guard_checkIn(
                              value: values, logTab: 0);
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
                          verify == 0
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
                                  '${'round'.tr} : ${widget.roundName}',
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    color: Theme.of(context).dividerColor,
                                    size: 25,
                                  )),
                              widget.roundId != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 10),
                                        textIcon(
                                            '${'interval'.tr} : ${createformat(widget.roundStart, 'T')} ${'to'.tr} ${createformat(widget.roundEnd, 'T')}',
                                            Icon(
                                              Icons.access_time_rounded,
                                              color: Theme.of(context)
                                                  .dividerColor,
                                              size: 25,
                                            )),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(height: 10),
                              textIcon(
                                  '${'checkpoint'.tr} : $checkpointName',
                                  Icon(
                                    Icons.maps_home_work_rounded,
                                    color: Theme.of(context).dividerColor,
                                    size: 25,
                                  )),
                              SizedBox(height: 10),
                              textIcon(
                                'checklist'.tr,
                                Icon(
                                  Icons.task_rounded,
                                  color: Theme.of(context).dividerColor,
                                  size: 25,
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: checkList.length,
                                  itemBuilder: ((context, index) =>
                                      checkList[index].checkpointName == ''
                                          ? Container()
                                          : CheckBox_FormField(
                                              title:
                                                  '${checkList[index].checkpointName}',
                                              value: false,
                                              validator: 'select_checklist'.tr,
                                            ))),
                              textIcon(
                                'add_image'.tr,
                                Icon(
                                  Icons.camera_alt_rounded,
                                  color: Theme.of(context).dividerColor,
                                  size: 25,
                                ),
                              ),
                              Add_Image(
                                type: ImageSource.camera,
                                count: 4,
                              ),
                              textIcon(
                                'event_record'.tr,
                                Icon(
                                  Icons.assignment_rounded,
                                  color: Theme.of(context).dividerColor,
                                  size: 25,
                                ),
                              ),
                              Dropdown_NoBorder(
                                title: 'select_event'.tr,
                                leftIcon: Icons.mobile_friendly,
                                error: 'select_event_pls'.tr,
                                listItem: listEvent
                                    .map(
                                      (e) => e['label']!,
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  final selected = listEvent.firstWhere(
                                      (item) => item['label'] == value);
                                  dropdownValue = selected['value'];
                                },
                              ),
                              TextForm_NoBorder_Validator(
                                typeInput: TextInputType.text,
                                controller: detail,
                                icon: Icons.description_rounded,
                                title: 'description'.tr,
                                validator: (values) {
                                  if (dropdownValue == 'abnormal' &&
                                      values.isEmpty) {
                                    return 'ab_enter_description'.tr;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              ExpansionTile(
                                collapsedBackgroundColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
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
                                  verify == 0
                                      ? Container()
                                      : Map_Page(
                                          lat: widget.lat,
                                          lng: widget.lng,
                                          area_lat: listdata[0].lat,
                                          area_lng: listdata[0].lng,
                                          radius: 20.0,
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
        );
      }),
    );
  }
}
