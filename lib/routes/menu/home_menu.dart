// ignore_for_file: unused_import

import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/screen/estamp_service/estamp_page.dart';
import 'package:flutter/material.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/qr_smart_access/smart_accress_menu.dart';
// import 'package:doormster/screen/security_guard/security_guard_page.dart';
import 'package:doormster/screen/security_guard/security_guard_menu.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
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
                return const Home_Page();
              case Routes.qrsmart:
                return const Smart_Accress_Menu();
              case Routes.security:
                return const Security_Guard_Menu();
              case Routes.visitor:
                return const Visitor_Service();
              case Routes.estamp:
                return const Estamp_Page();
              default:
                throw Exception('Invalid route: ${routeSettings.name}');
            }
          },
        );
      },
    );
  }
}
