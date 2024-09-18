import 'dart:async';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/controller/home_controller.dart';
import 'package:doormster/controller/news_controller.dart';
import 'package:doormster/controller/profile_controller.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

NavbarNotifier navbarNotifier = NavbarNotifier();

class NavbarNotifier extends ChangeNotifier {
  FutureOr<bool> onBackButtonPressed(int index) async {
    bool exitingApp = true;
    switch (index) {
      case 0:
        if (Keys.home?.currentState != null &&
            Keys.home!.currentState!.canPop()) {
          Keys.home?.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 1:
        if (Keys.news?.currentState != null &&
            Keys.news!.currentState!.canPop()) {
          Keys.news?.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 2:
        if (Keys.notify?.currentState != null &&
            Keys.notify!.currentState!.canPop()) {
          Keys.notify?.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 3:
        if (Keys.profile?.currentState != null &&
            Keys.profile!.currentState!.canPop()) {
          Keys.profile?.currentState!.pop();
          exitingApp = false;
        }
        break;
      default:
        return false;
    }
    if (exitingApp) {
      return true;
    } else {
      return false;
    }
  }

  void popAllRoutes(int index) async {
    switch (index) {
      case 0:
        if (Keys.home?.currentState != null &&
            Keys.home!.currentState!.canPop()) {
          Keys.home?.currentState?.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 0) {
          Homecontroller.GetMenu();
        }
        return;
      case 1:
        if (Keys.news?.currentState != null &&
            Keys.news!.currentState!.canPop()) {
          Keys.news?.currentState!.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 1) {
          news_controller.get_News(branch_id: branchController.branch_Id.value);
        }
        return;
      case 2:
        if (Keys.notify?.currentState != null &&
            Keys.notify!.currentState!.canPop()) {
          Keys.notify?.currentState!.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 2) {
          Keys.notify?.currentState?.pushReplacement(
            GetPageRoute(
                page: () => const Notification_Page(),
                transitionDuration: Duration.zero),
          );
        }
        return;
      case 3:
        if (Keys.profile?.currentState != null &&
            Keys.profile!.currentState!.canPop()) {
          Keys.profile?.currentState!.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 3) {
          profileController.get_Profile(loadingTime: 100);
        }
        return;
      default:
        break;
    }
  }
}
