import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/main.dart';
import 'package:doormster/screen/main_screen/auth_page.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/change_password_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/screen/main_screen/settings_page.dart';
import 'package:doormster/screen/management_service/management_service_page.dart';
import 'package:doormster/screen/parcel_service/parcel_service_page.dart';
import 'package:doormster/screen/qr_smart_access/qr_smart_home_page.dart';
import 'package:doormster/screen/security_guard/security_guard_page.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> pages_routes = {
  '/check': (context) => Check_Connected(),
  '/auth': (context) => Auth_Page(),
  '/login': (context) => Login_Page(),
  '/staff': (context) => Login_Staff(),
  '/home': (context) => Home_Page(),
  '/bottom': (context) => BottomBar(),
  '/qrsmart': (context) => QRSmart_HomePage(),
  '/parcel': (context) => Parcel_service(),
  '/management': (context) => Management_Service(),
  '/security': (context) => Security_Guard(),
  '/visitor': (context) => Visitor_Service(),
  '/password': (context) => Password_Page(),
  '/setting': (context) => Settings_Page(),
};
