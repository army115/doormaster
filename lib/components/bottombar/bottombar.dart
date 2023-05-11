// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/snackbar/back_double.dart';
import 'package:doormster/routes/menu/home_menu.dart';
import 'package:doormster/routes/menu/notification_menu.dart';
import 'package:doormster/routes/menu/profile_menu.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/main_screen/notification_page.dart';
import 'package:doormster/screen/main_screen/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> messageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();
final NavbarNotifier _navbarNotifier = NavbarNotifier();
late TabController _tabController;
int _selectedIndex = _tabController.index;

class BottomBar extends StatefulWidget {
  BottomBar({
    Key? key,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  final buildBody = [
    Home_Menu(navigatorKey: homeKey),
    Notification_Menu(navigatorKey: messageKey),
    Profile_Menu(navigatorKey: profileKey),
  ];

  @override
  void initState() {
    super.initState();
    // _selectedIndex = 0;
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: Duration(
        seconds: 0,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _ontapItem(int index) {
    if (_navbarNotifier._index == index) {
      _navbarNotifier.popAllRoutes(index);
    } else {
      _navbarNotifier._index = index;
    }
    setState(() {
      _tabController.animateTo(index);
      _selectedIndex = index;
    });
  }

  DateTime PressTime = DateTime.now();

  Future<bool> _onBackButtonDoubleClicked() async {
    if (_scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.of(context).pop();
    } else {
      final bool isExitingApp =
          await _navbarNotifier.onBackButtonPressed(_selectedIndex);

      if (isExitingApp) {
        if (_selectedIndex != 0) {
          setState(() {
            _tabController.animateTo(0);
            _selectedIndex = 0;
          });
        } else {
          int difference = DateTime.now().difference(PressTime).inMilliseconds;
          PressTime = DateTime.now();

          if (difference < 1500) {
            SystemNavigator.pop(animated: true);
          } else {
            backDouble(context);
          }
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonDoubleClicked(),
      child: Scaffold(
        drawerEnableOpenDragGesture: false,
        key: _scaffoldKey,
        drawer: MyDrawer(
          ontapItem: (int index) {
            setState(() {
              _tabController.animateTo(index);
              _selectedIndex = index;
            });
          },
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: buildBody,
        ),
        // IndexedStack(
        //   index: _selectedIndex,
        //   children: buildBody,
        // ),
        // buildBody[
        //     _selectedIndex], //จะไม่ค้างอยู่หน้าปัจจุบัน เวลากดปุ่มเมนูกลับมา

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _ontapItem,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: 'แจ้งเตือน',
              // icon: Icon(Icons.message_rounded),
              // label: 'ข้อความ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'โปรไฟล์',
            ),
          ],
        ),
      ),
    );
  }
}

class NavbarNotifier extends ChangeNotifier {
  int _index = 0;

  FutureOr<bool> onBackButtonPressed(int index) async {
    bool exitingApp = true;
    switch (index) {
      case 0:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 1:
        if (messageKey.currentState != null &&
            messageKey.currentState!.canPop()) {
          messageKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 2:
        if (profileKey.currentState != null &&
            profileKey.currentState!.canPop()) {
          profileKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      default:
        return false;
    }
    if (exitingApp) {
      return true;
    } else {
      return false;
    }
  }

  void popAllRoutes(int index) async {
    switch (index) {
      case 0:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState?.popUntil((route) => route.isFirst);
        } else if (_selectedIndex == 0) {
          homeKey.currentState?.pushReplacement(PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> animation2) {
              return Home_Page();
            },
            // transitionDuration: Duration.zero,
            // reverseTransitionDuration: Duration.zero,
          ));
        }
        return;
      case 1:
        if (messageKey.currentState != null &&
            messageKey.currentState!.canPop()) {
          messageKey.currentState!.popUntil((route) => route.isFirst);
        }
        if (_selectedIndex == 1) {
          messageKey.currentState?.pushReplacement(PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> animation2) {
              return Notification_Page();
            },
            // transitionDuration: Duration.zero,
            // reverseTransitionDuration: Duration.zero,
          ));
        }
        return;
      case 2:
        if (profileKey.currentState != null &&
            profileKey.currentState!.canPop()) {
          profileKey.currentState!.popUntil((route) => route.isFirst);
        } else if (_selectedIndex == 2) {
          profileKey.currentState?.pushReplacement(PageRouteBuilder(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> animation2) {
              return Profile_Page();
            },
            // transitionDuration: Duration.zero,
            // reverseTransitionDuration: Duration.zero,
          ));
        }
        return;
      default:
        break;
    }
  }
}
