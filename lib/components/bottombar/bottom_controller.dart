// ignore_for_file: unused_element

import 'dart:developer';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/bottombar/navbar.dart';
import 'package:doormster/components/snackbar/back_double.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

BottomController bottomController = BottomController();

class BottomController extends GetxController
    with SingleGetTickerProviderMixin {
  var selectedIndex = 0.obs;
  late TabController tabController;

  BottomController() {
    tabController =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void ontapItem(int index) {
    if (navbarNotifier.index == index) {
      navbarNotifier.popAllRoutes(index);
    } else {
      navbarNotifier.index = index;
    }
    tabController.animateTo(index);
    selectedIndex.value = index;
  }

  DateTime PressTime = DateTime.now();

  Future<bool> onBackButtonDoubleClicked(context) async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      Get.back();
    } else {
      final bool isExitingApp =
          await navbarNotifier.onBackButtonPressed(selectedIndex.value);

      if (isExitingApp) {
        if (selectedIndex != 0.obs) {
          tabController.animateTo(0);
          selectedIndex = 0.obs;
        } else {
          int difference = DateTime.now().difference(PressTime).inMilliseconds;
          PressTime = DateTime.now();

          if (difference < 1500) {
            SystemNavigator.pop(animated: true);
          } else {
            backDouble(context);
          }
        }
      }
    }
    return false;
  }
}
