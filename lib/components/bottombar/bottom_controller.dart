// ignore_for_file: unused_element

import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/bottombar/navbar.dart';
import 'package:doormster/components/snackbar/back_double.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

BottomController bottomController = Get.put(BottomController());

class BottomController extends GetxController
    with SingleGetTickerProviderMixin {
  RxInt selectedIndex = 0.obs;
  late TabController tabController;

  BottomController() {
    tabController =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void ontapItem(int index) {
    if (selectedIndex.value == index) {
      navbarNotifier.popAllRoutes(index);
    }
    tabController.animateTo(index);
    selectedIndex.value = index;
  }

  DateTime pressTime = DateTime.now();

  Future<bool> onBackButtonDoubleClicked(context) async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      Get.back();
    } else {
      final bool isExitingApp =
          await navbarNotifier.onBackButtonPressed(selectedIndex.value);

      if (isExitingApp) {
        if (selectedIndex.value != 0) {
          tabController.animateTo(0);
          selectedIndex.value = 0;
        } else {
          int difference = DateTime.now().difference(pressTime).inMilliseconds;
          pressTime = DateTime.now();

          if (difference < 1500) {
            return isExitingApp;
          } else {
            backDouble(context);
          }
        }
      }
    }
    return false;
  }
}
