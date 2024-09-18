// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:doormster/components/bottombar/navigation_ids.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:doormster/components/bottombar/bottombar.dart';

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
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case '/':
            builder = (BuildContext context) => Notification_Page();
            break;
          default:
            throw Exception('Invalid route: ${routeSettings.name}');
        }
        return MaterialPageRoute(
          settings: routeSettings,
          builder: builder,
        );
      },
    );
  }
}
