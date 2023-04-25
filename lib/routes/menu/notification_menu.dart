// ignore_for_file: use_key_in_widget_constructors

import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:doormster/components/bottombar/bottombar.dart';

class Notification_Menu extends StatefulWidget {
  final navigatorKey;
  const Notification_Menu({Key? key, this.navigatorKey});

  @override
  State<Notification_Menu> createState() => _Notification_MenuState();
}

class _Notification_MenuState extends State<Notification_Menu> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      onGenerateRoute: (routeSettings) {
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case '/':
            builder = (BuildContext context) => Notification_Page();
            break;
          // case '/qrsmart':
          //   builder = (BuildContext context) => QRSmart_HomePage();
          //   break;
          // case '/parcel':
          //   builder = (BuildContext context) => Parcel_service();
          //   break;
          // case '/managemant':
          //   builder = (BuildContext context) => Managemant_Service();
          //   break;
          // case '/security':
          //   builder = (BuildContext context) => Security_Guard();
          //   break;
          // case '/visitor':
          //   builder = (BuildContext context) => Visitor_Service();
          //   break;
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
