import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class Loading extends StatefulWidget {
  Loading({
    Key? key,
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    configLoading();
    showDialogLoading();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  void configLoading() {
    EasyLoading.instance
      ..textAlign = TextAlign.center
      ..animationDuration = Duration.zero
      ..loadingStyle = EasyLoadingStyle.light
      ..maskType = EasyLoadingMaskType.black
      ..dismissOnTap = false
      ..userInteractions = false
      ..indicatorWidget = CircularProgressIndicator()
      ..contentPadding = EdgeInsets.fromLTRB(25, 25, 25, 20)
      ..fontSize = 16
      ..textStyle = TextStyle(height: 2, color: Colors.black)
      ..radius = 10.0;
  }

  Future<void> showDialogLoading() async {
    await EasyLoading.show(
      status: 'Loading...',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
