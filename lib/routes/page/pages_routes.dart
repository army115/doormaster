// ignore_for_file: constant_identifier_names

import 'package:doormster/check_connected_page.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/screen/main_screen/auth_page.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/change_password_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:doormster/screen/main_screen/profile_page.dart';
import 'package:doormster/screen/main_screen/settings_page.dart';
import 'package:doormster/screen/management_service/management_service_page.dart';
import 'package:doormster/screen/parcel_service/parcel_service_page.dart';
import 'package:doormster/screen/qr_smart_access/smart_accress_menu.dart';
import 'package:doormster/screen/qr_smart_access/visitor_page.dart';
import 'package:doormster/screen/security_guard/security_guard_menu.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PagesRoutes {
  PagesRoutes._();

  static final routes = [
    GetPage(
      name: Routes.auth,
      page: () => Auth_Page(),
    ),
    GetPage(
      name: Routes.check,
      page: () => const Check_Connected(),
    ),
    GetPage(
      name: Routes.login_user,
      page: () => Login_Page(),
    ),
    GetPage(
      name: Routes.login_staff,
      page: () => Login_Staff(),
    ),
    GetPage(
      name: Routes.bottom,
      page: () => BottomBar(),
    ),
    GetPage(
      name: Routes.home,
      page: () => Home_Page(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const Profile_Page(),
    ),
    GetPage(
      name: Routes.setting,
      page: () => const Settings_Page(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const Notification_Page(),
    ),
    GetPage(
      name: Routes.password,
      page: () => Password_Page(),
    ),
    GetPage(
      name: Routes.qrsmart,
      page: () => const Smart_Accress_Menu(),
    ),
    GetPage(
      name: Routes.security,
      page: () => Security_Guard_Menu(),
    ),
    GetPage(
      name: Routes.visitor,
      page: () => Visitor_Service(),
    ),
    GetPage(
      name: Routes.parcel,
      page: () => Parcel_service(),
    ),
    GetPage(
      name: Routes.management,
      page: () => Management_Service(),
    ),
  ];
}
