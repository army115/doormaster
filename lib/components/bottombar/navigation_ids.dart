import 'package:get/get.dart';

abstract class Keys {
  Keys._();
  static final home = Get.nestedKey(NavigationIds.home);
  static final news = Get.nestedKey(NavigationIds.news);
  static final notify = Get.nestedKey(NavigationIds.notify);
  static final profile = Get.nestedKey(NavigationIds.profile);
}

abstract class NavigationIds {
  NavigationIds._();
  static const home = 1;
  static const news = 2;
  static const notify = 3;
  static const profile = 4;
}
