// ignore_for_file: unused_import, use_build_context_synchronously, sort_child_properties_last, prefer_const_constructors, deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/components/searchbar/search_from.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;
// import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class Opendoor_Page extends StatefulWidget {
  Opendoor_Page({Key? key}) : super(key: key);

  @override
  State<Opendoor_Page> createState() => _Opendoor_PageState();
}

class _Opendoor_PageState extends State<Opendoor_Page> {
  // var token;
  // var companyId;
  // var deviceId;
  // var weiganId;

  // TextEditingController fieldText = TextEditingController();

  // List<Lists> listDevice = [];
  // List<Lists> devicelidt = [];
  // List<DataWiegand> listWeigan = [];
  // List<Det>? listdet = [];
  // List<Det>? detlist = [];
  // bool loading = false;
  // late SharedPreferences prefs;

  // Future getValueShared() async {
  //   prefs = await SharedPreferences.getInstance();

  //   token = prefs.getString('token');
  //   companyId = prefs.getString('companyId');
  //   deviceId = prefs.getString('deviceId');
  //   weiganId = prefs.getString('weiganId');

  //   // print('token: ${token}');
  //   // print('companyId: ${companyId}');
  //   // print('deviceId: ${deviceId}');
  //   // print('weiganId: ${weiganId}');

  //   _getDoorDevice();
  // }

  // Future _getDoorDevice() async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });

  //     if (deviceId != null) {
  //       //call api device
  //       var url = '${IP_Address.old_IP}getdeviceuuidmobile/$deviceId';
  //       var res = await Dio().get(
  //         url,
  //         options: Options(headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         }),
  //       );
  //       if (res.statusCode == 200) {
  //         if (res.data == 'มีบางอย่างผิดพลาด') {
  //           listDevice = [];
  //         } else {
  //           DoorsDeviece deviceDoors = DoorsDeviece.fromJson(res.data);
  //           setState(() {
  //             listDevice = deviceDoors.lists!;
  //             devicelidt = listDevice;
  //           });
  //         }
  //       }
  //     }

  //     //call api Weigan
  //     var urlWeigan =
  //         '${IP_Address.old_IP}get/weigan_group_id/$weiganId/$companyId';
  //     var response = await Dio().get(
  //       urlWeigan,
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       getDoorWiegand doorsWeigan = getDoorWiegand.fromJson(response.data);

  //       setState(() {
  //         listWeigan = doorsWeigan.data!;
  //         detlist = listdet;
  //       });
  //       // วน loop เพื่อดึง Det จากแต่ละ DataWeigan
  //       for (int i = 0; i < listWeigan.length; i++) {
  //         // เก็บ List Det จาก DataWeigan ลงในตัวแปร listdet
  //         listdet?.addAll(listWeigan[i].det!);
  //       }
  //     }
  //   } catch (error) {
  //     print(error);
  //     if (deviceId == null) {
  //     } else {
  //       error_Connected(() {
  //         Keys.home?.currentState?.popUntil(ModalRoute.withName('/qrsmart'));
  //         Navigator.of(context, rootNavigator: true).pop();
  //       });
  //     }
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  // Future _openDoors(devSn) async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });
  //     var url = '${IP_Address.old_IP}openDevice/$companyId/$devSn';
  //     var response = await Dio().post(url,
  //         options: Options(headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         }));

  //     if (response.statusCode == 200) {
  //       var jsonRes = openDoorsModel.fromJson(response.data);
  //       if (jsonRes.data!.code == 0) {
  //         print('DeviceNumber : ${devSn}');
  //         print('OpenDoor Success');
  //         print('Status : ${jsonRes.data!.code}');
  //         snackbar(Theme.of(context).primaryColor, 'door_open_success'.tr,
  //             Icons.check_circle_outline_rounded);
  //       } else if (jsonRes.data!.code == 10000) {
  //         print('DeviceNumber : ${devSn}');
  //         print('Door Offline');
  //         print('Status : ${jsonRes.data!.code}');
  //         snackbar(Colors.red, 'door_offline'.tr, Icons.highlight_off_rounded);
  //       } else if (jsonRes.data!.code == 10400) {
  //         print('DeviceNumber : ${devSn}');
  //         print('Invalid Device');
  //         print('Status : ${jsonRes.data!.code}');
  //         snackbar(
  //             Colors.red, 'invalid_device'.tr, Icons.highlight_off_rounded);
  //       }
  //     } else {
  //       snackbar(Colors.red, 'door_open_fail'.tr, Icons.highlight_off_rounded);
  //       print('OpenDoor Fail!!');
  //       print(response.data);
  //     }
  //   } catch (error) {
  //     print(error);
  //     error_Connected(() async {
  //       Get.back();
  //     });
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  // Future _openDoorsWeigan(DoorId, Num) async {
  //   try {
  //     setState(() {
  //       loading = true;
  //     });
  //     var url = '${IP_Address.old_IP}openDoorweigan';
  //     print(url);
  //     var response = await Dio().post(url,
  //         options: Options(headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //         }),
  //         data: {
  //           "door_id": DoorId,
  //           "door_num": Num,
  //         });

  //     if (response.statusCode == 200) {
  //       await Future.delayed(Duration(milliseconds: 400));
  //       print('OpenDoor Success');
  //       print('Status : ${response.data}');
  //       snackbar(Theme.of(context).primaryColor, 'door_open_success'.tr,
  //           Icons.check_circle_outline_rounded);
  //     } else {
  //       snackbar(Colors.red, 'door_open_fail'.tr, Icons.highlight_off_rounded);
  //       print('OpenDoor Fail!!');
  //       print(response.data);
  //     }
  //   } catch (error) {
  //     print(error);
  //     error_Connected(() {
  //       Navigator.of(context, rootNavigator: true).pop();
  //     });
  //   } finally {
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    // getValueShared();
  }

  // void _searchData(String text) {
  //   setState(() {
  //     listdet = detlist?.where((item) {
  //       var date = item.doorName!;
  //       return date.contains(text);
  //     }).toList();
  //     listDevice = devicelidt.where((item) {
  //       var date = item.name!;
  //       return date.contains(text);
  //     }).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('open_door'.tr),
        ),
        body: Logo_Opacity(title: 'contact_admin_door'.tr)
        //  Column(
        //     children: [
        //       Container(
        //           padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
        //           child: Search_From(
        //             title: 'search_door'.tr,
        //             searchText: fieldText,
        //             clear: () {
        //               setState(() {
        //                 fieldText.clear();
        //                 listdet = detlist;
        //                 listDevice = devicelidt;
        //               });
        //             },
        //             changed: (value) {
        //               _searchData(value);
        //             },
        //           )),
        //       Expanded(
        //         child: listDevice.isEmpty && listdet!.isEmpty
        //             ? Logo_Opacity(title: 'door_not_found'.tr)
        //             : RefreshIndicator(
        //                 onRefresh: () async {
        //                   getValueShared();
        //                 },
        //                 child: SingleChildScrollView(
        //                   padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
        //                   child: Column(
        //                     children: [
        //                       ListView.builder(
        //                         shrinkWrap: true,
        //                         primary: false,
        //                         itemCount: listDevice.length,
        //                         itemBuilder: (context, index) {
        //                           return Card(
        //                               shape: RoundedRectangleBorder(
        //                                   borderRadius:
        //                                       BorderRadius.circular(10)),
        //                               margin: EdgeInsets.symmetric(
        //                                   vertical: 5),
        //                               elevation: 10,
        //                               child: listDevice[index].connectionStatus ==
        //                                       1
        //                                   ? doorsButton(
        //                                       '${listDevice[index].name}',
        //                                       'open_door'.tr,
        //                                       Icons.meeting_room_rounded,
        //                                       Get.textTheme.bodyLarge
        //                                           ?.color,
        //                                       Theme.of(context)
        //                                           .primaryColorDark,
        //                                       () => _openDoors(
        //                                           listDevice[index]
        //                                               .devSn))
        //                                   : doorsButton(
        //                                       '${listDevice[index].name}',
        //                                       'offline_door'.tr,
        //                                       Icons
        //                                           .no_meeting_room_rounded,
        //                                       Colors.white,
        //                                       Colors.red,
        //                                       () => snackbar(
        //                                           Colors.red,
        //                                           'door_offline'.tr,
        //                                           Icons
        //                                               .highlight_off_rounded)));
        //                         },
        //                       ),
        //                       ListView.builder(
        //                         shrinkWrap: true,
        //                         primary: false,
        //                         itemCount: listdet?.length,
        //                         itemBuilder: (context, index) {
        //                           return Card(
        //                               shape: RoundedRectangleBorder(
        //                                   borderRadius:
        //                                       BorderRadius.circular(10)),
        //                               margin: EdgeInsets.symmetric(
        //                                   vertical: 5),
        //                               elevation: 5,
        //                               child: doorsButton(
        //                                   '${listdet?[index].doorName}',
        //                                   'open_door'.tr,
        //                                   Icons.meeting_room_rounded,
        //                                   Get.textTheme.bodyLarge?.color,
        //                                   Theme.of(context)
        //                                       .primaryColorDark,
        //                                   () => _openDoorsWeigan(
        //                                       listdet?[index].doorId,
        //                                       listdet?[index].doorNum)));
        //                         },
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //       ),
        //     ],
        //   ),
        );
  }

  Widget doorsButton(name, button, icon, textColor, color, press) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      title: Text(name, style: Theme.of(context).textTheme.bodySmall),
      trailing: ElevatedButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5,
          // primary: textColor,
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        ),
        child: Wrap(
          children: [
            Icon(
              icon,
              color: textColor,
              size: 30,
            ),
            SizedBox(
              width: 3,
            ),
            Text(
              button,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        onPressed: press,
      ),
    );
  }
}
