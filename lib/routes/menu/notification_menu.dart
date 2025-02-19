// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:doormster/screen/qr_smart_access/list_visitor_page.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:get/get.dart';

class Notification_Menu extends StatefulWidget {
  const Notification_Menu({Key? key});

  @override
  State<Notification_Menu> createState() => _Notification_MenuState();
}

class _Notification_MenuState extends State<Notification_Menu> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.notify,
      onGenerateRoute: (routeSettings) {
        Widget pageRoutes;
        List<Bindings> bindings;
        switch (routeSettings.name) {
          case '/':
            pageRoutes = const Notification_Page();
            bindings = [];
            break;
          case '/listvisitor':
            pageRoutes = const ListVisitor();
            bindings = [];
            break;
          default:
            throw Exception('Invalid route: ${routeSettings.name}');
        }
        return GetPageRoute(
            settings: routeSettings,
            page: () => pageRoutes,
            bindings: bindings);
      },
    );
  }
}
