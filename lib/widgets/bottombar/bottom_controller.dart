// ignore_for_file: unused_element

import 'dart:developer';

import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/bottombar/navbar.dart';
import 'package:doormster/widgets/snackbar/back_double.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

BottomController bottomController = BottomController();

class BottomController extends GetxController
    with SingleGetTickerProviderMixin {
  RxInt selectedIndex = 0.obs;
  RxInt notificationCount = 0.obs;
  RxList notifications = [].obs;
  late TabController tabController;

  BottomController() {
    tabController =
        TabController(length: 4, vsync: this, animationDuration: Duration.zero);
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
  }

  void ontapItem(int index) {
    if (selectedIndex.value == index) {
      navbarNotifier.popAllRoutes(index);
    }
    if (index == 2) {
      notificationCount.value = 0;
    }
    if (index == 3) {
      scaffoldKey.currentState!.openEndDrawer();
    } else {
      tabController.animateTo(index);
      selectedIndex.value = index;
    }
  }

  DateTime pressTime = DateTime.now();

  Future<bool> onBackButtonDoubleClicked(context) async {
    if (scaffoldKey.currentState?.isEndDrawerOpen ?? false) {
      return true;
    } else {
      final bool isExitingApp =
          await navbarNotifier.onBackButtonPressed(selectedIndex.value);

      if (isExitingApp) {
        if (selectedIndex.value != 0) {
          tabController.animateTo(0);
          selectedIndex.value = 0;
          return false;
        } else {
          int difference = DateTime.now().difference(pressTime).inMilliseconds;
          pressTime = DateTime.now();

          if (difference < 1500) {
            return isExitingApp;
          } else {
            backDouble(context);
            return false;
          }
        }
      }
    }
    return false;
  }
}
