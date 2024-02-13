import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: non_constant_identifier_names
void form_error_snackbar() {
  snackbar(Colors.orange, 'enter_info_error'.tr, Icons.warning_amber_rounded);
}
