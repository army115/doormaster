import 'dart:async';
import 'package:doormster/widgets/bottombar/bottom_controller.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/controller/main_controller/home_controller.dart';
import 'package:doormster/controller/main_controller/news_controller.dart';
import 'package:doormster/controller/main_controller/profile_controller.dart';
import 'package:flutter/material.dart';

NavbarNotifier navbarNotifier = NavbarNotifier();

class NavbarNotifier extends ChangeNotifier {
  Future<bool> onBackButtonPressed(int index) async {
    return await _checkCanPop(Keys.getStateByIndex(index + 1));
  }

  Future<bool> _checkCanPop(GlobalKey<NavigatorState>? key) async {
    if (key?.currentState?.canPop() ?? false) {
      key?.currentState?.pop();
      return false;
    }
    return true;
  }

  void popAllRoutes(int index) {
    var key = Keys.getStateByIndex(index + 1);
    if (key?.currentState != null && !key!.currentState!.canPop()) {
      _handleNonPop(index);
    } else {
      key?.currentState?.popUntil((route) => route.isFirst);
    }
  }

  void _handleNonPop(int index) {
    switch (index) {
      case 0:
        homeController.Get_Info();
        break;
      case 1:
        newsController.get_News();
        break;
      case 2:
        bottomController.notifications.clear();
        break;
      case 3:
        profileController.get_Profile(loadingTime: 100);
        break;
    }
  }
}
