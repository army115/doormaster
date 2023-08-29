// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/screen/main_screen/profile_page.dart';
import 'package:flutter/material.dart';

class Profile_Menu extends StatefulWidget {
  const Profile_Menu({Key? key});

  @override
  State<Profile_Menu> createState() => _Profile_MenuState();
}

class _Profile_MenuState extends State<Profile_Menu> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: profileKey,
      onGenerateRoute: (routeSettings) {
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case '/':
            builder = (BuildContext context) => Profile_Page();
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
