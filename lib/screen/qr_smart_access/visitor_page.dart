// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/datetime/date_time.dart';
import 'package:doormster/components/dropdown/dropdown.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text_form/text_form.dart';
import 'package:doormster/components/text_form/text_form_null.dart';
import 'package:doormster/components/text_form/text_form_number.dart';
import 'package:doormster/components/text_form/text_form_ontap.dart';
import 'package:doormster/models/device_group.dart';
import 'package:doormster/models/getdoor_wiegand.dart';
import 'package:doormster/models/visitor_model.dart';
import 'package:doormster/models/wiegand_model.dart';
import 'package:doormster/screen/qr_smart_access/visitor_detail_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final devices = TextEditingController();
  final types = TextEditingController();
  final selectDevices = TextEditingController();

  var onItemSelect;
  var userId;
  var companyId;
  var deviceId;
  var weiganId;

  List<DataDrvices> listDevice = [];
  List<DataWiegand> listWeigan = [];
  List<Det>? listdet = [];
  List<Det>? detlist = [];
  bool loading = false;

  Future _getDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    companyId = prefs.getString('companyId');
    deviceId = prefs.getString('deviceId');
    weiganId = prefs.getString('weiganId');

    print('userId: ${userId}');
    print('companyId: ${companyId}');
    print('deviceId: ${deviceId}');
    print('weiganId: ${weiganId}');

    if (deviceId != null && weiganId != null) {
      types.text = '';
    } else if (deviceId != null) {
      types.text = 'thinmoo';
    } else if (weiganId != null) {
      types.text = 'wiegand';
    } else {
      types.text = 'null';
    }

    try {
      setState(() {
        loading = true;
      });
      if (deviceId != null) {
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
      }
      if (weiganId != null) {
        //call api Weigan
        var urlWeigan =
            '${Connect_api().domain}/get/weigan_group_id/$weiganId/$companyId';
        var response = await Dio().get(
          urlWeigan,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
        );

        if (response.statusCode == 200) {
          getDoorWiegand doorsWeigan = getDoorWiegand.fromJson(response.data);

          setState(() {
            listWeigan = doorsWeigan.data!;
            detlist = listdet;
            loading = false;
          });
          // วน loop เพื่อดึง Det จากแต่ละ DataWeigan
          listWeigan.forEach((value) => listdet?.addAll(value.det!));
        }
      }
      setState(() {
        loading = false;
      });
    } catch (error) {
      print(error);
      error_connected(context, () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future _createVisitor(Map<String, dynamic> values) async {
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
        snackbar(Get.theme.primaryColor, 'create_qrcode_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        snackbar(
            Colors.red, 'create_qrcode_fail'.tr, Icons.highlight_off_rounded);
        print('craate Visitor Fail!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      error_connected(context, () async {
        Navigator.of(context).pop();
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future _createVisitorWiegand(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/createVisitorWeigan/$companyId';
      var response = await Dio().post(url,
          options: Options(headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          }),
          data: values);

      if (response.statusCode == 200) {
        var visitorData;
        var QRcodeData;
        WiegandModel wiegandModel = WiegandModel.fromJson(response.data);
        visitorData = [
          wiegandModel.visitorName,
          wiegandModel.visitorPeople,
          wiegandModel.startDate,
          wiegandModel.endDate,
          wiegandModel.telVisitor,
          wiegandModel.usableCount,
          wiegandModel.qrcode
        ];
        log(visitorData.toString());

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
        snackbar(Get.theme.primaryColor, 'create_qrcode_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        snackbar(
            Colors.red, 'create_qrcode_fail'.tr, Icons.highlight_off_rounded);
        print('craate Visitor Fail!!');
        print(response.data);
        setState(() {
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      error_connected(context, () async {
        Navigator.of(context).pop();
      });
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
          appBar: AppBar(title: Text('create_visitor'.tr)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _button(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _kye,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('visitor_name'.tr),
                            Text_Form(
                              controller: visitName,
                              title: 'fullname'.tr,
                              icon: Icons.person,
                              error: 'enter_name_visitor'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text('contacts'.tr),
                            Text_Form(
                              controller: visitPeople,
                              title: 'fullname'.tr,
                              icon: Icons.person_outline,
                              error: 'enter_name_contacts'.tr,
                              TypeInput: TextInputType.name,
                            ),
                            Text('phone'.tr),
                            TextForm_Number(
                              controller: phone,
                              title: 'phone_number'.tr,
                              icon: Icons.phone,
                              type: TextInputType.name,
                              maxLength: 10,
                              error: (values) {
                                if (values.isEmpty) {
                                  return 'enter_phone'.tr;
                                } else if (values.length < 10) {
                                  return "phone_10char".tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            deviceId != null && weiganId != null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('device_type'.tr),
                                      dropdownType(),
                                    ],
                                  )
                                : Container(),
                            types.text != ''
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('access'.tr),
                                      types.text == 'thinmoo'
                                          ? dropdownDecives()
                                          : types.text == 'wiegand'
                                              ? wiegandDevice()
                                              : TextForm_Null(
                                                  title: 'no_device'.tr,
                                                  errortext: 'no_device'.tr,
                                                  iconleft:
                                                      Icons.mobile_friendly,
                                                  iconright: Icons
                                                      .keyboard_arrow_down_rounded,
                                                ),
                                    ],
                                  )
                                : Container(),
                            Text('start'.tr),
                            Date_time(
                                controller: startDate,
                                title: 'pick_date'.tr,
                                leftIcon: Icons.event_note_rounded,
                                error: 'select_date'.tr),
                            Text('end'.tr),
                            Date_time(
                                controller: endDate,
                                title: 'pick_date'.tr,
                                leftIcon: Icons.event_note_rounded,
                                error: 'select_date'.tr),
                            types.text == 'thinmoo'
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('access_count'.tr),
                                      TextForm_Number(
                                        controller: useCount,
                                        title: 'count'.tr,
                                        icon: Icons.add_circle_outline_sharp,
                                        type: TextInputType.name,
                                        maxLength: 2,
                                        error: (values) {
                                          if (values.isEmpty) {
                                            return 'enter_access_count'.tr;
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
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

  Widget _button() {
    return Buttons(
        title: 'create_qrcode'.tr,
        press: () {
          if (_kye.currentState!.validate()) {
            if (types.text == "thinmoo") {
              Map<String, dynamic> valuse = Map();
              valuse['devsns'] = onItemSelect;
              valuse['usableCount'] = useCount.text;
              valuse['startDate'] = startDate.text;
              valuse['endDate'] = endDate.text;
              valuse['visitor_name'] = visitName.text;
              valuse['tel_visitor'] = phone.text;
              valuse['visipeople'] = visitPeople.text;
              valuse['created_by'] = userId;
              valuse['typeDevices'] = "thinmoo";
              _createVisitor(valuse);
            } else if (types.text == "wiegand") {
              Map<String, dynamic> valuse = Map();
              valuse['weiganId'] = weiganId;
              valuse['usableCount'] = "1";
              valuse['startDate'] = startDate.text;
              valuse['endDate'] = endDate.text;
              valuse['visitor_name'] = visitName.text;
              valuse['tel_visitor'] = phone.text;
              valuse['visipeople'] = visitPeople.text;
              valuse['created_by'] = userId;
              valuse['typeDevices'] = "wiegand";
              valuse['door_id'] = selectedItemsId;
              _createVisitorWiegand(valuse);
            }
          }
        });
  }

  Widget dropdownType() {
    return Dropdown(
        title: 'device_type'.tr,
        controller: types,
        leftIcon: Icons.app_settings_alt_rounded,
        onChanged: (value) {
          setState(() {
            types.text = value;
          });
          print(value);
        },
        error: 'select_type'.tr,
        listItem: ['thinmoo', 'wiegand']);
  }

  Widget dropdownDecives() {
    return Dropdown(
      title:
          deviceId == null || listDevice.isEmpty ? 'no_device'.tr : 'device'.tr,
      controller: devices,
      leftIcon: Icons.mobile_friendly,
      onChanged: (value) {
        final index = listDevice.indexWhere((item) => item.deviceName == value);
        if (index > -1) {
          onItemSelect = listDevice[index].deviceDevSn;
        }
        print(onItemSelect);
      },
      error:
          deviceId == null || listDevice.isEmpty ? 'no_device'.tr : 'device'.tr,
      listItem: listDevice.map((value) => value.deviceName.toString()).toList(),
    );
  }

  Widget wiegandDevice() {
    return TextForm_Ontap(
      controller: selectDevices,
      title:
          weiganId == null || listWeigan.isEmpty ? 'no_device'.tr : 'device'.tr,
      errortext:
          weiganId == null || listWeigan.isEmpty ? 'no_device'.tr : 'device'.tr,
      iconleft: Icons.mobile_friendly,
      iconright: Icons.keyboard_arrow_down_rounded,
      ontap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => WillPopScope(
            onWillPop: (() async => false),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 80),
                child: SelectableItems()),
          ),
        );
      },
    );
  }

  List<bool> selectedItems = [];
  List<String> selectedItemsName = [];
  List<String> selectedItemsId = [];

  Widget SelectableItems() {
    TextEditingController fieldText = TextEditingController();
    void _searchData(String text) {
      setState(() {
        listdet = detlist?.where((item) {
          var name = item.doorName!.toLowerCase();
          return name.contains(text);
        }).toList();
      });
    }

    if (selectedItems.isEmpty) {
      //set ค่า ใน list ให้เป็น bool = false
      selectedItems = List<bool>.filled(listdet!.length, false);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Scaffold(
        appBar: AppBar(
          title: Text('device'.tr),
          leading: button_back(() {
            Navigator.pop(context);
            fieldText.clear();
          }),
        ),
        body: Column(
          children: [
            // Container(
            //     padding: EdgeInsets.all(10),
            //     child: Search_From(
            //       title: 'ค้นหาประตู',
            //       fieldText: fieldText,
            //       clear: () {
            //         setState(() {
            //           fieldText.clear();
            //           listdet = detlist;
            //         });
            //       },
            //       changed: (value) {
            //         log(fieldText.text);
            //         _searchData(value);
            //         setState(() {});
            //       },
            //     )),
            Expanded(
              child: listdet!.isEmpty
                  ? Logo_Opacity(title: 'device_not_found'.tr)
                  : ListView.builder(
                      padding: EdgeInsets.only(bottom: 10),
                      itemCount: listdet?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String? item = listdet![index].doorName;
                        final String? id = listdet![index].doorId;

                        return CheckboxListTileFormField(
                          // dense: true,
                          activeColor: Get.theme.primaryColor,
                          title: Text(
                            item!,
                            style: TextStyle(fontSize: 16),
                          ),
                          initialValue: selectedItems[index],
                          onChanged: (value) {
                            setState(() {
                              selectedItems[index] = value;
                              if (selectedItemsName.contains(item)) {
                                selectedItemsName.remove(item);
                                selectedItemsId.remove(id);
                                selectDevices.text =
                                    selectedItemsName.join(',');
                              } else {
                                selectedItemsName.add(item);
                                selectedItemsId.add(id!);
                                selectDevices.text =
                                    selectedItemsName.join(',');
                              }

                              log(selectedItems.toString());
                              log("devicesName : ${selectedItemsName}");
                              log("devicesId : ${selectedItemsId}");
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
