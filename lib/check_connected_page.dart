import 'dart:io';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Check_Connected extends StatelessWidget {
  const Check_Connected({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/HIP_Smart_Community_Logo_White.png',
                        scale: 4,
                      ),
                    ),
                    Image.asset(
                      'assets/images/HIP_Branding_White.png',
                      scale: 4,
                    ),
                  ],
                ),
              ),
              Container(
                height: double.infinity,
                color: Colors.black38,
                child: Platform.isAndroid
                    ? dialogmain(
                        'occur_error'.tr,
                        'connect_error'.tr,
                        Icons.warning_amber_rounded,
                        Colors.orange,
                        'ok'.tr, () {
                        SystemNavigator.pop();
                      })
                    : _showErrorIOS(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showErrorIOS() {
    return AlertDialog(
        titlePadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: Colors.orange,
            ),
            Text(
              'occur_error'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'connect_error'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ));
  }
}
