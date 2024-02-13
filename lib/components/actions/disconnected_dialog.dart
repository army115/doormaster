// ignore_for_file: non_constant_identifier_names

import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void error_connected(navigator) {
  dialogOnebutton_Subtitle(
      'found_error'.tr,
      'connect_fail'.tr,
      Icons.warning_amber_rounded,
      Colors.orange,
      'ok'.tr,
      navigator,
      false,
      false);
}
