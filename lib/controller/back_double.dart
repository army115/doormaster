import 'package:doormster/components/snackbar/back_double.dart';
import 'package:flutter/services.dart';

DateTime PressTime = DateTime.now();
Future<bool> onBackButtonDoubleClicked(context) async {
  int difference = DateTime.now().difference(PressTime).inMilliseconds;
  PressTime = DateTime.now();
  if (difference < 1500) {
    SystemNavigator.pop(animated: true);
    return true;
  } else {
    backDouble(context);
    return false;
  }
}
