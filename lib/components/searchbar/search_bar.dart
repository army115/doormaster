// ignore_for_file: prefer_const_constructors

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Search_Bar extends StatefulWidget {
  String title;
  final changed;
  var fieldText;
  final clear;
  Search_Bar(
      {Key? key, required this.title, this.changed, this.fieldText, this.clear})
      : super(key: key);

  @override
  State<Search_Bar> createState() => _Search_BarState();
}

class _Search_BarState extends State<Search_Bar> {
  DateFormat formater = DateFormat('y-MM-dd');

  String? selectDate;

  void calenda() async {
    final datePicker = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
          lastDate: DateTime.now(),
          calendarType: CalendarDatePicker2Type.single,
          cancelButton: Text(
            'ยกเลิก',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          okButton: Text(
            'ตกลง',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          )),
      dialogSize: const Size(300, 400),
      borderRadius: BorderRadius.circular(10),
    );

    selectDate = datePicker != null && datePicker == []
        ? formater.format(datePicker.single!)
        : formater.format(DateTime.now());

    widget.fieldText.text = selectDate;

    print(selectDate);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 10,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: TextField(
          controller: widget.fieldText,
          // cursorColor: Colors.cyan,
          decoration: InputDecoration(
            hintText: widget.title,
            hintStyle: TextStyle(color: Colors.black38, fontSize: 16),
            prefixIcon: Icon(
              Icons.search,
              size: 30,
            ),
            suffixIcon:
                // widget.fieldText.text.isNotEmpty
                //     ? IconButton(
                //         onPressed: widget.clear,
                //         icon: Icon(
                //           Icons.close,
                //           size: 30,
                //         ))
                //     :
                IconButton(
                    onPressed: () => calenda(),
                    icon: Icon(
                      Icons.event_note,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
            border: InputBorder.none,
            // contentPadding:
            //     EdgeInsets.symmetric(horizontal: 25, vertical: 13)
          ),
          onChanged: widget.changed),
    );
  }
}
