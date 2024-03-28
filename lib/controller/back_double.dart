import 'package:doormster/components/snackbar/back_double.dart';
import 'package:flutter/services.dart';

Future<bool> onBackDoubleClicked(context, pressTime) async {
  int difference = DateTime.now().difference(pressTime).inMilliseconds;
  pressTime = DateTime.now();
  if (difference < 1500) {
    SystemNavigator.pop(animated: true);
    return true;
  } else {
    backDouble(context);
    return false;
  }
}
