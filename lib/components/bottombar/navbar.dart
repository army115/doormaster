import 'dart:async';
import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/main_screen/news_page.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:doormster/screen/main_screen/profile_page.dart';
import 'package:flutter/material.dart';

NavbarNotifier navbarNotifier = NavbarNotifier();

class NavbarNotifier extends ChangeNotifier {
  FutureOr<bool> onBackButtonPressed(int index) async {
    bool exitingApp = true;
    switch (index) {
      case 0:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 1:
        if (newsKey.currentState != null && newsKey.currentState!.canPop()) {
          newsKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 2:
        if (notifyKey.currentState != null &&
            notifyKey.currentState!.canPop()) {
          notifyKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 3:
        if (profileKey.currentState != null &&
            profileKey.currentState!.canPop()) {
          profileKey.currentState!.pop();
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
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState?.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 0) {
          homeKey.currentState?.pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, animation2) => Home_Page(),
            ),
          );
        }
        return;
      case 1:
        if (newsKey.currentState != null && newsKey.currentState!.canPop()) {
          newsKey.currentState!.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 1) {
          newsKey.currentState?.pushReplacement(
            PageRouteBuilder(
                pageBuilder: (BuildContext context, animation, animation2) =>
                    const News_Page()),
          );
        }
        return;
      case 2:
        if (notifyKey.currentState != null &&
            notifyKey.currentState!.canPop()) {
          notifyKey.currentState!.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 2) {
          notifyKey.currentState?.pushReplacement(
            PageRouteBuilder(
                pageBuilder: (BuildContext context, animation, animation2) =>
                    const Notification_Page()),
          );
        }
        return;
      case 3:
        if (profileKey.currentState != null &&
            profileKey.currentState!.canPop()) {
          profileKey.currentState!.popUntil((route) => route.isFirst);
        } else if (bottomController.selectedIndex.value == 3) {
          profileKey.currentState?.pushReplacement(
            PageRouteBuilder(
                pageBuilder: (BuildContext context, animation, animation2) =>
                    const Profile_Page()),
          );
        }
        return;
      default:
        break;
    }
  }
}
