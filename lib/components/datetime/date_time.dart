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
  DateTime? dateSelect;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: PhysicalModel(
        borderRadius: BorderRadius.circular(10),
        elevation: 10,
        color: Colors.white,
        child: TextFormField(
          style: TextStyle(fontSize: 16),
          controller: widget.controller,
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            prefixIcon: Icon(
              widget.leftIcon,
              size: 25,
            ),
            suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, size: 30),
            hintText: widget.title,
            hintStyle: TextStyle(fontSize: 16),
            errorStyle: TextStyle(fontSize: 15),
            // filled: true, พื้นหลังช่อง
            // fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
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
                String datetime = DateFormat('y-MM-dd HH:mm').format(date);
                setState(() {
                  widget.controller.text = datetime;
                  dateSelect = date;
                });
                print(datetime);
              },
              currentTime: dateSelect == null ? DateTime.now() : dateSelect!,
              locale: LocaleType.th,
              theme: DatePickerTheme(
                titleHeight: 45,
                headerColor: Theme.of(context).primaryColor,
                cancelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Prompt'),
                doneStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Prompt'),
                backgroundColor: Colors.grey.shade200,
                itemHeight: 40,
                itemStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Prompt'),
                containerHeight: MediaQuery.of(context).size.height * 0.4,
              ),
            );
          },
        ),
      ),
    );
  }
}
