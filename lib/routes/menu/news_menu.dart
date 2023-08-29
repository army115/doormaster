// ignore_for_file: use_key_in_widget_constructors, unused_import

import 'package:doormster/screen/main_screen/news_page.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:doormster/components/bottombar/bottombar.dart';

class News_Menu extends StatefulWidget {
  const News_Menu({Key? key});

  @override
  State<News_Menu> createState() => _News_MenuState();
}

class _News_MenuState extends State<News_Menu> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: newsKey,
      onGenerateRoute: (routeSettings) {
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case '/':
            builder = (BuildContext context) => News_Page();
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
