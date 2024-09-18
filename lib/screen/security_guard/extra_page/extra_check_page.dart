// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:doormster/components/actions/form_error_snackbar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/checkBox/checkbox_formfield.dart';
import 'package:doormster/components/dropdown/dropdown_noborder.dart';
import 'package:doormster/components/image/add_iamges.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/components/text_form/text_form_noborder.dart';
import 'package:doormster/components/text_form/text_form_noborder_validator.dart';
import 'package:doormster/controller/add_images_controller.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/controller/security_controller/check_in_controller.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class Extra_Check extends StatefulWidget {
  final String? title;
  final int? type;
  const Extra_Check({super.key, this.title, this.type});

  @override
  State<Extra_Check> createState() => _Extra_CheckState();
}

class _Extra_CheckState extends State<Extra_Check> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController pointName = TextEditingController();
  TextEditingController detail = TextEditingController();
  String branchId = branchController.branch_Id.value;
  String? checkpointName;
  DateTime dateNow = DateTime.now();
  Position? position;
  double? lat;
  double? lng;
  List<String> listcheck = [];
  String? dropdownValue;
  List<Map<String, String>> listEvent = [
    {'value': 'normal', 'label': 'normal'.tr},
    {'value': 'abnormal', 'label': 'abnormal'.tr}
  ];

  final listImage = addImagesController.listImage;

  Future getLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      setState(() {
        lat = position?.latitude;
        lng = position?.longitude;
      });
    } catch (error) {
      print(error);
      Navigator.of(context, rootNavigator: true).pop();
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
    getLocation();
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
        Get.back();
        return false;
      },
      child: Obx(
        () => Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(widget.title!.tr),
                leading: button_back(() {
                  Get.back();
                }),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: connectApi.loading.isTrue
                  ? Container()
                  : Buttons(
                      title: 'save'.tr,
                      press: () async {
                        List<dio.MultipartFile> files = [];
                        for (int i = 0; i < listImage.length; i++) {
                          files.add(await dio.MultipartFile.fromFile(
                            listImage[i].path,
                            filename: listImage[i].name,
                          ));
                        }
                        if (_formkey.currentState!.validate()) {
                          Map<String, dynamic> values = Map();
                          values['branch_id'] = branchId;
                          values['lat'] = lat;
                          values['lng'] = lng;
                          values['outside_location_name'] = pointName.text;
                          values['checkpoint_list_other'] =
                              jsonEncode(listcheck);
                          values['is_outside_cycle'] = '1';
                          values['is_outside_checkpoint'] = '1';
                          values['description'] = detail.text;
                          values['status'] = dropdownValue ?? 'abnormal';
                          values['event'] = dropdownValue ?? 'emergency';
                          values['files'] = files;
                          checkInController.guard_checkIn(
                              value: values, logTab: 1);
                        } else {
                          form_error_snackbar();
                        }
                      }),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Form(
                  key: _formkey,
                  child: connectApi.loading.isTrue
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
                                  '${'round'.tr} : ${widget.type == 0 ? 'extra_point'.tr : 'emergency'.tr}',
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    color: Theme.of(context).dividerColor,
                                    size: 25,
                                  )),
                              Text_Form_NoBorder(
                                  controller: pointName,
                                  title: 'checkpoint_name'.tr,
                                  icon: textIcon(
                                      '${'checkpoint'.tr} : ',
                                      Icon(Icons.maps_home_work_rounded,
                                          size: 25,
                                          color:
                                              Theme.of(context).dividerColor)),
                                  error: 'checkpoint_name'.tr,
                                  TypeInput: TextInputType.text),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  textIcon(
                                    'checklist'.tr,
                                    Icon(
                                      Icons.task_rounded,
                                      color: Theme.of(context).dividerColor,
                                      size: 25,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Theme.of(context)
                                                      .primaryColorDark)),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => addChecklist(),
                                        );
                                      },
                                      child: textIcon(
                                        'add_checklist'.tr,
                                        color: Get.textTheme.bodyLarge?.color,
                                        fontsize: 14,
                                        Icon(
                                          Icons.add_box,
                                          color: Get.textTheme.bodyLarge?.color,
                                          size: 22,
                                        ),
                                      )),
                                ],
                              ),
                              // SizedBox(height: 10),
                              ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: listcheck.length,
                                  itemBuilder: ((context, index) =>
                                      CheckBox_FormField(
                                        title: listcheck[index],
                                        value: false,
                                        validator: 'select_checklist'.tr,
                                        secondary: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listcheck
                                                    .remove(listcheck[index]);
                                              });
                                            },
                                            icon: Icon(
                                              Icons
                                                  .remove_circle_outline_rounded,
                                              color: Colors.red,
                                            )),
                                      ))),
                              SizedBox(
                                height: 10,
                              ),
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
                              widget.type == 1
                                  ? Container()
                                  : textIcon(
                                      'event_record'.tr,
                                      Icon(
                                        Icons.assignment_rounded,
                                        color: Theme.of(context).dividerColor,
                                        size: 25,
                                      ),
                                    ),
                              widget.type == 1
                                  ? Container()
                                  : Dropdown_NoBorder(
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
                                  'current_position'.tr,
                                  Icon(
                                    Icons.location_on_sharp,
                                    size: 25,
                                    color: Colors.red.shade600,
                                  ),
                                ),
                                children: [
                                  lat == null
                                      ? Container()
                                      : Map_Page(
                                          lat: lat!,
                                          lng: lng!,
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

  Widget addChecklist() {
    final _fieldkey = GlobalKey<FormState>();
    TextEditingController fieldText = TextEditingController();
    return Form(
      key: _fieldkey,
      child: AlertDialog(
        title: Text(
          'add_checklist'.tr,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                'cancel'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
          TextButton(
              onPressed: () {
                if (_fieldkey.currentState!.validate()) {
                  setState(() {
                    listcheck.add(fieldText.text);
                    print(listcheck);
                  });
                  Get.back();
                } else {
                  form_error_snackbar();
                }
              },
              child: Text(
                'submit'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
        content: TextFormField(
          autofocus: true,
          controller: fieldText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: 'enter_checklist'.tr,
            hintStyle: TextStyle(fontSize: 16),
            errorStyle: TextStyle(fontSize: 15),
            icon: Icon(
              Icons.checklist,
              size: 30,
            ),
          ),
          validator: (values) {
            if (values!.isEmpty) {
              return 'enter_info_pls'.tr;
            }
            return null;
          },
        ),
      ),
    );
  }
}
