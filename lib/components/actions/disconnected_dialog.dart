// ignore_for_file: non_constant_identifier_names

import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void error_Connected(navigator, {click, back_btn}) {
  dialogOnebutton_Subtitle(
      title: 'occur_error'.tr,
      subtitle: 'connect_error'.tr,
      icon: Icons.warning_rounded,
      colorIcon: Colors.orange,
      textButton: 'ok'.tr,
      press: navigator,
      click: click ?? false,
      backBtn: back_btn ?? false,
      willpop: click ?? false);
}

void error_Timeout(navigator, {click, back_btn}) {
  dialogOnebutton_Subtitle(
      title: 'error_timeout'.tr,
      subtitle: 'connect_timeout'.tr,
      icon: Icons.error,
      colorIcon: Colors.red,
      textButton: 'ok'.tr,
      press: navigator,
      click: click ?? false,
      backBtn: back_btn ?? false,
      willpop: click);
}
