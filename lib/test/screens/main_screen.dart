// import 'package:common_bottom_navigation_bar/components/common_navigation_bar.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/messages_page.dart';
import 'package:doormster/screen/profile_page.dart';
import 'package:doormster/test/screens/screen2.dart';
// import 'package:common_bottom_navigation_bar/components/bottom_bar_navigator.dart';
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
        bottomNavigationBar: BottomAppBar(
          color: Colors.amber,
          shape: CircularNotchedRectangle(),
          notchMargin: 5,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: AnimatedBottomNav(
                currentIndex: _selectedIndex,
                onChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: _selectedIndex,
        //   // showSelectedLabels: false,
        //   // showUnselectedLabels: false,
        //   items: const [
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.home,
        //       ),
        //       label: 'HOME',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.calendar_month,
        //       ),
        //       label: 'CALENDAR',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(
        //         Icons.person,
        //       ),
        //       label: 'PROFILE',
        //     ),
        //   ],
        //   onTap: (index) {
        //     setState(() {
        //       _selectedIndex = index;
        //     });
        //   },
        // ),
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

  // Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
  //   return {
  //     '/': (context) {
  //       return [
  //         HomePage(),
  //         CalendarPage(),
  //         ProfilePage(),
  //       ].elementAt(index);
  //     },
  //   };
  // }

  getPage(BuildContext context, int index) {
    return {
      '/': (context) {
        switch (index) {
          case 0:
            return Home_Page();
          case 1:
            return Massages_Page();
          case 2:
            return Profile_Page();
        }
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = getPage(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final currentIndex;
  final onChange;
  const AnimatedBottomNav({Key? key, this.currentIndex, this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      // decoration: BoxDecoration(color: Colors.amber),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => onChange(0),
              child: Icon(Icons.home),
            ),
          ),
          // Expanded(
          //   child: InkWell(
          //     onTap: () => onChange(1),
          //     child: BottomNavItem(
          //       icon: Icons.receipt_outlined,
          //       title: 'รายการ',
          //       isActive: currentIndex == 1,
          //     ),
          //   ),
          // ),
          // Expanded(
          //   child: InkWell(
          //     onTap: () => onChange(2),
          //     child: BottomNavItem(
          //       icon: Icons.paid_outlined,
          //       // icon: Icons.attach_money,
          //       title: 'ชำระเงิน',
          //       isActive: currentIndex == 2,
          //     ),
          //   ),
          // ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(1),
              child: Icon(
                Icons.message,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
                onTap: () => onChange(2),
                child: Icon(
                  Icons.person,
                )),
          ),
        ],
      ),
    );
  }
}
