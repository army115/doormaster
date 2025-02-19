// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables, use_super_parameters

import 'package:doormster/controller/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchCalendar extends StatelessWidget {
  final String title;
  final VoidCallback? onClear;
  final VoidCallback? onTap;

  const SearchCalendar(
      {Key? key, required this.title, this.onClear, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calendarController = Get.find<CalendarController>();

    return Card(
      margin: EdgeInsets.zero,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Obx(
        () => TextField(
          readOnly: true,
          controller: calendarController.fieldText.value,
          style: TextStyle(
            fontSize: 15,
            color: calendarController.fieldText.value.text.contains('วันที่') ||
                    calendarController.fieldText.value.text.contains('Select')
                ? Colors.grey
                : Get.theme.dividerColor,
          ),
          decoration: InputDecoration(
            hintText: title,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
            prefixIcon: Icon(
              Icons.event_note,
              color: Theme.of(context).primaryColorDark,
              size: 30,
            ),
            suffixIcon:
                calendarController.fieldText.value.text.contains('วันที่') ||
                        calendarController.fieldText.value.text
                            .contains('Select') ||
                        calendarController.fieldText.value.text == ''
                    ? null
                    : IconButton(
                        onPressed: onClear,
                        icon: Icon(
                          Icons.close,
                          size: 30,
                          color: Colors.red,
                        )),
            border: InputBorder.none,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
