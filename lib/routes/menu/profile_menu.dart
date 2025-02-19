// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'package:doormster/widgets/bottombar/bottombar.dart';
import 'package:doormster/widgets/bottombar/navigation_ids.dart';
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
      key: Keys.profile,
      onGenerateRoute: (routeSettings) {
        WidgetBuilder builder;
        switch (routeSettings.name) {
          case '/':
            builder = (BuildContext context) => const Profile_Page();
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
