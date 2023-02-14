import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:flutter/material.dart';

class CheckBox_FormField extends StatefulWidget {
  final title;
  final value;
  final validator;
  const CheckBox_FormField({Key? key, this.title, this.value, this.validator});

  @override
  State<CheckBox_FormField> createState() => _CheckBox_FormFieldState();
}

class _CheckBox_FormFieldState extends State<CheckBox_FormField> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTileFormField(
      dense: true,
      activeColor: Theme.of(context).primaryColor,
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 16),
      ),
      initialValue: widget.value,
      onChanged: (value) {
        setState(() {
          value = widget.value;
        });
      },
      validator: (values) {
        if (values!) {
          return null;
        } else {
          return widget.validator;
        }
      },
    );
  }
}
