import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:flutter/material.dart';

void checkInternet(context, True, click) async {
  var check = await Connectivity().checkConnectivity();
  if (check != ConnectivityResult.none) {
    True;
  } else {
    dialogOnebutton_Subtitle(
        context,
        'พบข้อผิดพลาด',
        'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง', () {
      click;
    }, false);
    print('not connected');
  }
}
