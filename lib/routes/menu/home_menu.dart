// ignore_for_file: unused_import

import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/screen/management_service/management_service_page.dart';
import 'package:flutter/material.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/parcel_service/parcel_service_page.dart';
import 'package:doormster/screen/qr_smart_access/smart_accress_menu.dart';
// import 'package:doormster/screen/security_guard/security_guard_page.dart';
import 'package:doormster/screen/security_guard/security_guard_menu.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:get/get.dart';

class Home_Menu extends StatefulWidget {
  const Home_Menu({Key? key});

  @override
  State<Home_Menu> createState() => _Home_MenuState();
}

class _Home_MenuState extends State<Home_Menu> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.home,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          settings: routeSettings,
          builder: (context) {
            switch (routeSettings.name) {
              case '/':
                return Home_Page();
              case '/qrsmart':
                return const Smart_Accress_Menu();
              case '/parcel':
                return Parcel_service();
              case '/management':
                return Management_Service();
              case '/security':
                return Security_Guard_Menu();
              case '/visitor':
                return Visitor_Service();
              default:
                throw Exception('Invalid route: ${routeSettings.name}');
            }
          },
        );
      },
    );
  }
}
