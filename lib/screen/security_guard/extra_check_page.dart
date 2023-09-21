// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison, use_build_context_synchronously

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/checkBox/checkbox_formfield.dart';
import 'package:doormster/components/dropdown/dropdown_noborder.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/map/map_page.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text/text_icon.dart';
import 'package:doormster/components/text_form/text_form_noborder_validator.dart';
import 'package:doormster/screen/security_guard/report_logs_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController status = TextEditingController();

  var companyId;
  var userId;
  var language;
  bool loading = false;
  String? checkpointName;
  DateTime now = DateTime.now();
  Position? position;
  double? lat;
  double? lng;
  List<String> listcheck = [];
  String? onItemSelect;
  List<String> itemEvent_EN = ['Normal', 'Abnormal'];
  List<String> itemEvent_TH = ['ปกติ', 'ไม่ปกติ'];

  Future getSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('language');
    userId = prefs.getString('userId');
    companyId = prefs.getString('companyId');

    print('userId: ${userId}');
    print('companyId: ${companyId}');
  }

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

  Future _checkIn(Map<String, dynamic> values) async {
    try {
      setState(() {
        loading = true;
      });
      var url = '${Connect_api().domain}/created/extracheck';
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
            builder: (BuildContext context) => Report_Logs(tapIndex: 1),
          ),
        );
        snackbar(context, Theme.of(context).primaryColor, 'save_success'.tr,
            Icons.check_circle_outline_rounded);

        setState(() {
          loading = false;
        });
      } else {
        dialogOnebutton_Subtitle(context, 'found_error'.tr, 'save_unsuccess'.tr,
            Icons.highlight_off_rounded, Colors.red, 'ok'.tr, () {
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
    getSharedPref();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('dd-MM-y').format(now);
    String time = DateFormat('HH:mm:ss').format(now);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(widget.title!.tr),
              leading: button_back(() {
                Navigator.pop(context);
              }),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: loading
                ? Container()
                : Buttons(
                    title: 'save'.tr,
                    press: () {
                      if (_formkey.currentState!.validate()) {
                        Map<String, dynamic> valuse = Map();
                        // valuse['time'] = '${DateTime.now()}';
                        valuse['time'] = now.add(Duration(hours: 7)).toString();
                        // .toUtc() //todo ค่าเวลากลาง Utc + 0 ได้ค่ามี Z ต่อท้ายเวลา 2023-03-15 14:05:58.075406Z
                        //todo time zone + 7 ชม.
                        // .toIso8601String(); //todo ได้ค่ามี T ท้ายวันที่ 2023-03-15T14:45:36.325350
                        valuse['lat'] = lat;
                        valuse['lng'] = lng;
                        valuse['EmpID'] = userId;
                        valuse['id'] = companyId;
                        valuse['uuid'] = 'นอกจุด';
                        valuse['checkpoint_name'] = pointName.text;
                        valuse['CheckList'] = listcheck;
                        valuse['Round_uuid'] =
                            widget.type == 0 ? "นอกรอบ" : 'เหตุฉุกเฉิน';
                        valuse['Desciption'] = detail.text;
                        valuse['Status'] = "Extra";
                        valuse['EventCheck'] =
                            status.text != '' ? status.text : 'เหตุฉุกเฉิน';
                        valuse['pic'] = listImage64;
                        log(valuse.toString());
                        _checkIn(valuse);
                      }
                    }),
            body: SafeArea(
                child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: loading
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
                                '${'round'.tr} : ${widget.type == 0 ? 'extra_point'.tr : 'emergency'.tr}',
                                Icon(
                                  Icons.calendar_month_rounded,
                                  size: 25,
                                )),
                            TextFormField(
                              controller: pointName,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'checkpoint_name'.tr,
                                hintStyle: TextStyle(fontSize: 16),
                                errorStyle: TextStyle(fontSize: 15),
                                icon: textIcon(
                                    '${'checkpoint'.tr} : ',
                                    Icon(Icons.maps_home_work_rounded,
                                        size: 25, color: Colors.black)),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'checkpoint_name'.tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                textIcon(
                                  'checklist'.tr,
                                  Icon(
                                    Icons.task_rounded,
                                    size: 25,
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => addChecklist(),
                                      );
                                    },
                                    child: textIcon(
                                      'add_checklist'.tr,
                                      fontsize: 14,
                                      Icon(
                                        Icons.add_box,
                                        size: 22,
                                      ),
                                    )),
                              ],
                            ),
                            // SizedBox(height: 10),
                            ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: listcheck.length,
                                itemBuilder: ((context, index) =>
                                    CheckBox_FormField(
                                      title: '${listcheck[index]}',
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
                                            Icons.remove_circle_outline_rounded,
                                            color: Colors.red,
                                          )),
                                    ))),
                            SizedBox(
                              height: 10,
                            ),
                            textIcon(
                              'illustration'.tr,
                              Icon(
                                Icons.camera_alt_rounded,
                                size: 25,
                              ),
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

                            textIcon(
                              'event_record'.tr,
                              Icon(
                                Icons.assignment_rounded,
                                size: 25,
                              ),
                            ),
                            widget.type == 1
                                ? Container()
                                : Dropdown_NoBorder(
                                    title: 'select_event'.tr,
                                    controller: status,
                                    leftIcon: Icons.mobile_friendly,
                                    error: 'select_event_pls'.tr,
                                    listItem: language == 'th'
                                        ? itemEvent_TH
                                        : itemEvent_EN,
                                    onChanged: (value) {
                                      final int index;
                                      //เปรียบเทียบค่า เพื่อหาค่า index จาก listItem
                                      if (language == 'th') {
                                        index = itemEvent_TH.indexWhere(
                                            (item) => item == value);
                                      } else {
                                        index = itemEvent_EN.indexWhere(
                                            (item) => item == value);
                                      }
                                      //นำค่า index ที่ได้มาเลือก item
                                      if (index > -1) {
                                        onItemSelect = itemEvent_TH[index];
                                      }
                                      print(onItemSelect);
                                    },
                                  ),
                            TextForm_NoBorder_Validator(
                              typeInput: TextInputType.text,
                              controller: detail,
                              icon: Icons.description_rounded,
                              title: 'desciption'.tr,
                              validator: (values) {
                                if (onItemSelect == 'ไม่ปกติ' &&
                                    values.isEmpty) {
                                  return 'enter_desciption'.tr;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            ExpansionTile(
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
                                Map_Page(
                                  extra: 'extra',
                                  lat: lat,
                                  lng: lng,
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
                Navigator.pop(context);
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
                  });
                  Navigator.pop(context);
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
