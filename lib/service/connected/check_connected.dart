import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> checkInternet(
    {required Widget page, navigationId, onGoBack}) async {
  var result = await Connectivity().checkConnectivity();
  if (result == ConnectivityResult.none) {
    snackbar(
        Colors.orange, 'connect_internet_pls'.tr, Icons.warning_amber_rounded);
  } else {
    if (onGoBack != null) {
      Get.to(() => page, id: navigationId)!.then(
        (_) => onGoBack(),
      );
    } else {
      Get.to(() => page, id: navigationId);
    }
  }
}

Future<void> checkInternetName({required page, onGoBack}) async {
  var result = await Connectivity().checkConnectivity();
  debugPrint("result: $result");
  if (result == ConnectivityResult.none) {
    snackbar(
        Colors.orange, 'connect_internet_pls'.tr, Icons.warning_amber_rounded);
    debugPrint('not connected');
  } else {
    if (onGoBack != null) {
      Get.toNamed(page, id: NavigationIds.home)?.then(
        (_) => onGoBack(),
      );
    } else {
      Get.toNamed(page, id: NavigationIds.home);
    }
  }
}
