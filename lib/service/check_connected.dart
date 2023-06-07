import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:flutter/material.dart';

Future<void> checkInternet(context, page, rootNavi) async {
  var result = await Connectivity().checkConnectivity();
  print(result);
  if (result == ConnectivityResult.none) {
    snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
        Icons.warning_amber_rounded);
    print('not connected');
  } else {
    Navigator.of(context, rootNavigator: rootNavi)
        .push(MaterialPageRoute(builder: (context) => page));
  }
}

Future<void> checkInternetName(context, page, rootNavi) async {
  var result = await Connectivity().checkConnectivity();
  print(result);
  if (result == ConnectivityResult.none) {
    snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
        Icons.warning_amber_rounded);
    print('not connected');
  } else {
    Navigator.of(context, rootNavigator: rootNavi).pushNamed(page);
  }
}

Future<void> checkInternetOnGoBack(context, page, rootNavi, onGoBack) async {
  var result = await Connectivity().checkConnectivity();
  print(result);
  if (result == ConnectivityResult.none) {
    snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
        Icons.warning_amber_rounded);
    print('not connected');
  } else {
    Navigator.of(context, rootNavigator: rootNavi)
        .push(MaterialPageRoute(builder: (context) => page))
        .then((onGoBack));
  }
}
