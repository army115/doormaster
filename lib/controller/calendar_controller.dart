import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  var fieldText = TextEditingController().obs;
  var startDate = ''.obs;
  var endDate = ''.obs;
  var listDate = <DateTime?>[DateTime.now()].obs;
  final formatDate = DateFormat('y-MM-dd');
  final now = DateTime.now();

  void resetDate() {
    startDate.value = '';
    endDate.value = '';
    fieldText.value.text = '';
    listDate.value = [now];
  }

  void resetToDateNow() {
    startDate.value = formatDate.format(now);
    endDate.value = formatDate.format(now);
    fieldText.value.text =
        '${'pick_date'.tr} (${DateFormat('dd-MM-y').format(now)})';
    listDate.value = [now];
  }

  void updateDates(Map<String, dynamic> value) {
    startDate.value = value['startDate'];
    endDate.value = value['endDate'];
    fieldText.value.text = value['showDate'];
    listDate.value = value['listDate'];
  }
}
