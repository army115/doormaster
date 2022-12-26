import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class Date_time extends StatefulWidget {
  final controller;
  final title;
  final leftIcon;
  final error;
  Date_time({Key? key, this.controller, this.title, this.leftIcon, this.error})
      : super(key: key);

  @override
  State<Date_time> createState() => _Date_timeState();
}

class _Date_timeState extends State<Date_time> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        style: TextStyle(fontSize: 20),
        controller: widget.controller,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          prefixIcon: widget.leftIcon,
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
          hintText: widget.title,
          hintStyle: TextStyle(fontSize: 20),
          errorStyle: TextStyle(fontSize: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (values) {
          if (values!.isEmpty) {
            return widget.error;
          } else {
            return null;
          }
        },
        onTap: () {
          DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            onConfirm: (date) {
              String datetime = DateFormat('y-M-d HH:mm:ss').format(date);
              setState(() {
                widget.controller.text = datetime;
              });
              print(datetime);
            },
            currentTime: DateTime.now(),
            locale: LocaleType.th,
            theme: DatePickerTheme(
              titleHeight: 50,
              headerColor: Theme.of(context).primaryColor,
              cancelStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              doneStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              backgroundColor: Colors.grey.shade200,
              itemHeight: 45,
              itemStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.normal),
              containerHeight: MediaQuery.of(context).size.height * 0.4,
            ),
          );
        },
      ),
    );
  }
}
