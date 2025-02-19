// import 'package:checkbox_formfield/checkbox_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckBox_FormField extends StatelessWidget {
  final title;
  final value;
  final onChanged;
  final validator;
  final secondary;
  const CheckBox_FormField(
      {Key? key,
      this.title,
      this.value,
      this.validator,
      this.secondary,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTileFormField(
      side: BorderSide(color: Theme.of(context).dividerColor, width: 2),
      checkColor: Get.textTheme.bodyLarge?.color,
      secondary: secondary,
      dense: true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      activeColor: Theme.of(context).primaryColorDark,
      title: Text(
        title,
        style: Get.textTheme.bodyMedium,
      ),
      initialValue: value,
      onChanged: onChanged,
      validator: (values) {
        if (values!) {
          return null;
        } else {
          return validator;
        }
      },
    );
  }
}

class CheckboxListTileFormField extends FormField<bool> {
  CheckboxListTileFormField({
    Key? key,
    Widget? title,
    BuildContext? context,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    ValueChanged<bool>? onChanged,
    AutovalidateMode? autovalidateMode,
    bool enabled = true,
    bool dense = false,
    Color? errorColor,
    Color? activeColor,
    Color? checkColor,
    BorderSide? side,
    ListTileControlAffinity controlAffinity = ListTileControlAffinity.leading,
    EdgeInsetsGeometry? contentPadding,
    bool autofocus = false,
    Widget? secondary,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          builder: (FormFieldState<bool> state) {
            errorColor = Colors.red;
            return CheckboxListTile(
              title: title,
              dense: dense,
              activeColor: activeColor,
              checkColor: checkColor,
              side: side,
              value: state.value,
              onChanged: enabled
                  ? (value) {
                      state.didChange(value);
                      if (onChanged != null) onChanged(value!);
                    }
                  : null,
              subtitle: state.hasError
                  ? Text(
                      state.errorText!,
                      style: TextStyle(color: errorColor),
                    )
                  : null,
              controlAffinity: controlAffinity,
              secondary: secondary,
              contentPadding: contentPadding,
              autofocus: autofocus,
            );
          },
        );
}
