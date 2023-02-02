// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/menu/home_menu.dart';
import 'package:doormster/components/menu/message_menu.dart';
import 'package:doormster/components/menu/profile_menu.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/messages_page.dart';
import 'package:doormster/screen/profile_page.dart';
import 'package:doormster/screen/test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

final NavbarNotifier _navbarNotifier = NavbarNotifier();
GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> productsKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();

class BottomBar extends StatefulWidget {
  final page;
  BottomBar({Key? key, this.page});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final buildBody = [
    Home_Menu(),
    Message_Menu(),
    Profile_Menu(),
  ];
  int _selectedIndex = 0;
  final NavbarNotifier _navbarNotifier = NavbarNotifier();
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.page == null ? _selectedIndex : widget.page;
    print(_selectedIndex);
  }

  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();

  Future<bool> _onBackButtonDoubleClicked() async {
    final bool isExitingApp = await _navbarNotifier.onBackButtonPressed();
    if (isExitingApp) {
      newTime = DateTime.now();
      int difference = newTime.difference(oldTime).inMilliseconds;
      oldTime = newTime;
      if (difference < 1000) {
        // hideSnackBar();
        return isExitingApp;
      } else {
        Fluttertoast.showToast(
            msg: "กรุณากดอีกครั้งเพื่อออก",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).primaryColor,
            // textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }
    } else {
      return isExitingApp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonDoubleClicked(),
      // child: CupertinoTabScaffold(
      //   tabBar: CupertinoTabBar(
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home_rounded),
      //         label: 'หน้าหลัก',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.message_rounded),
      //         label: 'ข้อความ',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.school),
      //         label: 'โปรไฟล์',
      //       ),
      //     ],
      //     onTap: (index) {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //     },
      //   ),
      //   tabBuilder: (context, index) {
      //     // return Scaffold(
      //     //   body: _pageOptions[_selectedIndex],
      //     // );
      //     return DefaultTextStyle(
      //       style: TextStyle(
      //         fontFamily: '.SF UI Text',
      //         fontSize: 17.0,
      //         color: CupertinoColors.black,
      //       ),
      //       child: CupertinoTabView(
      //         builder: (BuildContext context) {
      //           return _pageOptions[index];
      //         },
      //       ),
      //     );
      //     // return CupertinoTabView(
      //     //   builder: (context) {
      //     //     return _pageOptions[_selectedIndex];
      //     //   },
      //     // );
      //   },
      // ),
      child: Scaffold(
        drawer: MyDrawer(),
        body: buildBody[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded),
              label: 'ข้อความ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'โปรไฟล์',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (value) {
            if (_navbarNotifier.index == value) {
              _navbarNotifier.popAllRoutes(value);
            }
            setState(() => _selectedIndex = value);
          },
        ),
      ),
    );
  }
}

class NavbarNotifier extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  FutureOr<bool> onBackButtonPressed() async {
    bool exitingApp = true;
    switch (_navbarNotifier.index) {
      case 0:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 1:
        if (productsKey.currentState != null &&
            productsKey.currentState!.canPop()) {
          productsKey.currentState!.pop();
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

  // pops all routes except first, if there are more than 1 route in each navigator stack
  void popAllRoutes(int index) {
    switch (index) {
      case 0:
        // if (homeKey.currentState!.canPop()) {
        homeKey.currentState?.popUntil((route) => route.isFirst);
        // }
        return;
      case 1:
        // if (productsKey.currentState!.canPop()) {
        productsKey.currentState!.popUntil((route) => route.isFirst);
        // }
        return;
      case 2:
        // if (profileKey.currentState!.canPop()) {
        profileKey.currentState!.popUntil((route) => route.isFirst);
        // }
        return;
      default:
        break;
    }
  }
}
