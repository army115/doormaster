import 'package:flutter/material.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/parcel_service/parcel_service_page.dart';
import 'package:doormster/screen/managemant_service/managemant_service_page.dart';
import 'package:doormster/screen/qr_smart_access/qr_smart_home_page.dart';
import 'package:doormster/screen/security_guard/security_guard_page.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:doormster/components/bottombar/bottombar.dart';

class Home_Menu extends StatelessWidget {
  Home_Menu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeKey,
      onGenerateRoute: (routeSettings) {
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case '/':
            builder = (BuildContext context) => Home_Page();
            break;
          case '/qrsmart':
            builder = (BuildContext context) => QRSmart_HomePage();
            break;
          case '/parcel':
            builder = (BuildContext context) => Parcel_service();
            break;
          case '/managemant':
            builder = (BuildContext context) => Managemant_Service();
            break;
          case '/security':
            builder = (BuildContext context) => Security_Guard();
            break;
          case '/visitor':
            builder = (BuildContext context) => Visitor_Service();
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
