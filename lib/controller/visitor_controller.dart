// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, invalid_use_of_protected_member

import 'package:get/get.dart';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/device_group.dart';
import 'package:doormster/models/getdoor_wiegand.dart';
import 'package:doormster/models/visitor_model.dart';
import 'package:doormster/models/wiegand_model.dart';
import 'package:doormster/screen/qr_smart_access/visitor_detail_page.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitorController extends GetxController {
  @override
  void onInit() async {
    getDevice();
    super.onInit();
  }

  @override
  void onClose() {
    listDevice.value.clear();
    listWeigan.value.clear();
    listdet.value.clear();
    detlist.value.clear();
    types.value.text = '';
    super.onClose();
  }

  Rx<TextEditingController> types = TextEditingController(text: '').obs;
  RxList listDevice = <DataDrvices>[].obs;
  RxList listWeigan = <DataWiegand>[].obs;
  RxList listdet = <Det>[].obs;
  RxList detlist = <Det>[].obs;
  RxBool loading = false.obs;

  var userId;
  var companyId;
  var deviceId;
  var weiganId;

  Future getDevice() async {
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
      types.value.text = '';
    } else if (deviceId != null) {
      types.value.text = 'thinmoo';
    } else if (weiganId != null) {
      types.value.text = 'wiegand';
    } else {
      types.value.text = 'null';
    }

    try {
      loading.value = true;

      await Future.delayed(Duration(milliseconds: 500));

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
          listDevice.assignAll(DeviceGroup.fromJson(response.data).data!);
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
          listWeigan.assignAll(getDoorWiegand.fromJson(response.data).data!);

          // วน loop เพื่อดึง Det จากแต่ละ DataWeigan
          for (var value in listWeigan) {
            listdet.addAll(value.det!);
          }
          detlist = listdet;
        }
      }
    } on DioError catch (e) {
      print(e);
      error_connected(() {
        Get.back(result: (route) => route.isFirst);
      });
    } finally {
      loading.value = false;
    }
  }

  Future createVisitorWiegand(Map<String, dynamic> values) async {
    try {
      loading.value = true;

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
        Get.to(Visitor_Detail(
          visitordData: visitorData,
          QRcodeData: QRcodeData,
        ));

        snackbar(Get.theme.primaryColor, 'create_qrcode_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        snackbar(
            Colors.red, 'create_qrcode_fail'.tr, Icons.highlight_off_rounded);
        print('craate Visitor Fail!!');
        print(response.data);
      }
    } on DioError catch (e) {
      print(e);
      error_connected(() async {
        Get.back();
      });
    } finally {
      loading.value = false;
    }
  }

  Future createVisitor(Map<String, dynamic> values) async {
    try {
      loading.value = true;

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
        Get.to(Visitor_Detail(
          visitordData: visitorData,
          QRcodeData: QRcodeData,
        ));

        snackbar(Get.theme.primaryColor, 'create_qrcode_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        snackbar(
            Colors.red, 'create_qrcode_fail'.tr, Icons.highlight_off_rounded);
        print('craate Visitor Fail!!');
        print(response.data);
      }
    } on DioError catch (e) {
      print(e);
      error_connected(() async {
        Get.back();
      });
    } finally {
      loading.value = false;
    }
  }
}
