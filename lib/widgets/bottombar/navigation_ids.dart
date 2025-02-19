import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class Keys {
  Keys._();
  static final home = Get.nestedKey(NavigationIds.home);
  static final news = Get.nestedKey(NavigationIds.news);
  static final notify = Get.nestedKey(NavigationIds.notify);
  static final profile = Get.nestedKey(NavigationIds.profile);

  static GlobalKey<NavigatorState>? getStateByIndex(int index) {
    switch (index) {
      case NavigationIds.home:
        return home;
      case NavigationIds.news:
        return news;
      case NavigationIds.notify:
        return notify;
      case NavigationIds.profile:
        return profile;
      default:
        return null;
    }
  }
}

abstract class NavigationIds {
  NavigationIds._();
  static const home = 1;
  static const news = 2;
  static const notify = 3;
  static const profile = 4;
}
