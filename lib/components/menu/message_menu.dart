import 'package:doormster/screen/messages_page.dart';
import 'package:flutter/material.dart';
import 'package:doormster/components/bottombar/bottombar.dart';

class Message_Menu extends StatelessWidget {
  Message_Menu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: productsKey,
      onGenerateRoute: (routeSettings) {
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case '/':
            builder = (BuildContext context) => Messages_Page();
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
