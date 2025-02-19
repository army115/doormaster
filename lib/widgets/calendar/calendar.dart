// ignore_for_file: non_constant_identifier_names

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Future CalendarPicker_SingleDate(
    {required BuildContext context, required DateTime dateValue}) async {
  DateFormat formatDate = DateFormat('y-MM-dd');
  final datePicker = await showCalendarDatePicker2Dialog(
    useSafeArea: false,
    context: context,
    value: [dateValue],
    config: CalendarDatePicker2WithActionButtonsConfig(
        selectedYearTextStyle: const TextStyle(color: Colors.white),
        yearTextStyle:
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        firstDayOfWeek: 1,
        weekdayLabelTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Theme.of(context).primaryColor),
        centerAlignModePicker: true,
        firstDate: DateTime.now(),
        calendarType: CalendarDatePicker2Type.single,
        cancelButton: Text(
          'cancel'.tr,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
        okButton: Text(
          'ok'.tr,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        )),
    dialogSize: const Size(350, double.minPositive),
    borderRadius: BorderRadius.circular(10),
  );

  if (datePicker != null) {
    var date = formatDate.format(datePicker[0]!);
    return date;
  }
  return null;
}

Future CalendarPicker_2Date(
    {required BuildContext context, required List<DateTime?> listDate}) async {
  DateFormat formatDate = DateFormat('y-MM-dd');
  DateFormat showFormatdate = DateFormat('dd-MM-y');

  final datePicker = await showCalendarDatePicker2Dialog(
    useSafeArea: false,
    context: context,
    value: listDate,
    config: CalendarDatePicker2WithActionButtonsConfig(
        selectedYearTextStyle: const TextStyle(color: Colors.white),
        yearTextStyle:
            const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        firstDayOfWeek: 1,
        weekdayLabelTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Theme.of(context).primaryColor),
        centerAlignModePicker: true,
        lastDate: DateTime.now(),
        calendarType: CalendarDatePicker2Type.range,
        cancelButton: Text(
          'cancel'.tr,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ),
        okButton: Text(
          'ok'.tr,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        )),
    dialogSize: const Size(350, double.minPositive),
    borderRadius: BorderRadius.circular(10),
  );

  if (datePicker != null) {
    //select 2 day
    if (datePicker.length == 2 && datePicker[0] != datePicker[1]) {
      var startDate = formatDate.format(datePicker[0]!);
      var endDate = formatDate.format(datePicker[1]!);

      var ShowStartDate = showFormatdate.format(datePicker[0]!);
      var ShowEndDate = showFormatdate.format(datePicker[1]!);

      //fieldText Controller
      var showDate = '$ShowStartDate ${'to'.tr} $ShowEndDate';

      return {
        "startDate": startDate,
        "endDate": endDate,
        "showDate": showDate,
        "listDate": datePicker
      };

      //select 1 day
    } else if (datePicker.length == 1) {
      //date ที่ได้จากการเลือกในปฏิทิน
      var startDate = formatDate.format(datePicker[0]!);
      var endDate = formatDate.format(datePicker[0]!);

      // //date ส่งไปแสดงหน้าแอพ
      var showDate = showFormatdate.format(datePicker[0]!);

      return {
        "startDate": startDate,
        "endDate": endDate,
        "showDate": showDate,
        "listDate": datePicker
      };
    }
  }
  return null;
}
