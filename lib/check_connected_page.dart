import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class Check_Connected extends StatelessWidget {
  const Check_Connected({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
        backgroundColor: Get.theme.primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/Smart Logo White.png',
                        scale: 4,
                      ),
                    ),
                    Image.asset(
                      'assets/images/banner.png',
                      scale: 4,
                    ),
                  ],
                ),
              ),
              Container(
                height: double.infinity,
                color: Colors.black38,
                child: dialogmain('occur_error'.tr, 'connect_error'.tr,
                    Icons.warning_amber_rounded, Colors.orange, 'ok'.tr, () {
                  Restart.restartApp();
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
