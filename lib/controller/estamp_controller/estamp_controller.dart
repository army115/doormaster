import 'package:doormster/service/connected/api_path.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EstampController extends GetxController {
  // ตัวแปรสำหรับจัดการสถานะ
  var selectedDiscountsName = <String>[].obs;
  var selectedDiscountsId = <String>[].obs;
  var tempSelectedDiscountsName = <String>[].obs;
  var tempSelectedDiscountsId = <String>[].obs;
  var finalHours = ''.obs;
  var finalMinutes = ''.obs;

  Future useEstamp(value) async {
    await connectApi.callApi_addData(
        ip: IP_Address.stamp_IP_server,
        path: EstampPath.UseEstamp,
        loadingTime: 100,
        values: value,
        showSuccess: () {
          dialogOnebutton(
              title: 'save_success'.tr,
              icon: Icons.check_circle_outline_rounded,
              colorIcon: Colors.green,
              textButton: 'ok'.tr,
              press: () {
                Get.until((route) => route.isFirst);
              },
              click: false,
              willpop: false);
        },
        showError: () {
          error_Connected(() {
            Get.back();
          });
        },
        showTimeout: () {
          error_Timeout(() {
            Get.back();
          });
        });
  }

  // ฟังก์ชันคำนวณเวลา
  void convertTime(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    finalHours.value = hours.toString();
    finalMinutes.value = minutes.toString();
  }

  // ฟังก์ชันอัปเดตรายการส่วนลด
  void updateSelectedItems(String label, String id, bool value) {
    if (value) {
      if (!tempSelectedDiscountsName.contains(label)) {
        tempSelectedDiscountsName.add(label);
        tempSelectedDiscountsId.add(id);
      }
    } else {
      tempSelectedDiscountsName.remove(label);
      tempSelectedDiscountsId.remove(id);
    }
  }

  void tempSelectedDiscounts() {
    tempSelectedDiscountsName.value = List.from(selectedDiscountsName);
    tempSelectedDiscountsId.value = List.from(selectedDiscountsId);
  }

  // ฟังก์ชันบันทึกส่วนลดที่เลือก
  void saveSelectedDiscounts() {
    selectedDiscountsName.value = List.from(tempSelectedDiscountsName);
    selectedDiscountsId.value = List.from(tempSelectedDiscountsId);
  }

  // ฟังก์ชันลบส่วนลด
  void removeDiscount(int index) {
    selectedDiscountsName.removeAt(index);
    selectedDiscountsId.removeAt(index);
  }
}
