import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:flutter/material.dart';

void checkInternet(context, page) async {
  var result = await Connectivity().checkConnectivity();
  print(result);
  if (result == ConnectivityResult.none) {
    snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
        Icons.warning_amber_rounded);
    print('not connected');
  } else {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => page,
    ));
  }
}
