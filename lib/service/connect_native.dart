import 'package:flutter/services.dart';

Future CallNativeJava(value, devSn, devMac, appKey) async {
  MethodChannel platform = MethodChannel('samples.flutter.dev/autoDoor');
  try {
    final result = await platform.invokeMethod('openAutoDoor',
        {"value": value, "devSn": devSn, "devMac": devMac, "appEkey": appKey});
    if (value == true) {
      print("ส่งค่า $result");
    }
    print("open :  $value");
  } on PlatformException catch (e) {
    '${e.message}';
  }
}
