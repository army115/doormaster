import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/test/screens/screen2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/calendar_page.dart';
import '../pages/calendar_page.dart';
import '../pages/calendar_page.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../pages/profile_page.dart';
import '../pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        drawer: MyDrawer(),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              label: 'HOME',
              activeIcon: Icon(
                Icons.home,
                color: Colors.purple,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.event,
                color: Colors.grey,
              ),
              label: 'CALENDAR',
              activeIcon: Icon(
                Icons.event,
                color: Colors.purple,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.grey,
              ),
              label: 'PROFILE',
              activeIcon: Icon(
                Icons.person,
                color: Colors.purple,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }

  void _next() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Screen2()));
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomePage(),
          CalendarPage(
            onNext: _next,
          ),
          ProfilePage(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    // var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          WidgetBuilder builder;
          switch (index) {
            case 0:
              builder = (BuildContext context) => HomePage();
              break;
            case 1:
              builder = (BuildContext context) => CalendarPage(
                    onNext: _next,
                  );
              break;
            case 2:
              builder = (BuildContext context) => ProfilePage();
              break;
            default:
              throw Exception('Invalid route: ${routeSettings}');
          }
          return MaterialPageRoute(
            settings: routeSettings,
            builder: builder,
          );
        },
      ),
    );
  }
}
