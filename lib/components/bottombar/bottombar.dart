// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/routes/menu/home_menu.dart';
import 'package:doormster/routes/menu/message_menu.dart';
import 'package:doormster/routes/menu/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> messageKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();
final NavbarNotifier _navbarNotifier = NavbarNotifier();
int _selectedIndex = 0;
bool loading = false;

class BottomBar extends StatefulWidget {
  final page;
  BottomBar({Key? key, this.page});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final buildBody = [
    Home_Menu(navigatorKey: homeKey),
    Message_Menu(navigatorKey: messageKey),
    Profile_Menu(navigatorKey: profileKey),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.page == null ? _selectedIndex : widget.page;
    print(_selectedIndex);
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
            _selectedIndex = 0;
          });
        } else {
          int difference = DateTime.now().difference(PressTime).inMilliseconds;
          PressTime = DateTime.now();

          if (difference < 1500) {
            SystemNavigator.pop(animated: true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.black87,
                content: Text(
                  "กดอีกครั้งเพื่อออก",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontFamily: 'Kanit'),
                ),
                width: MediaQuery.of(context).size.width * 0.45,
                padding: EdgeInsets.symmetric(vertical: 10),
                duration: const Duration(milliseconds: 1500),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            );
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
      child: Stack(
        children: [
          Scaffold(
            key: _scaffoldKey,
            drawer: MyDrawer(
              pressProfile: () {
                setState(() {
                  profileKey.currentState?.popAndPushNamed('/');
                  _selectedIndex = 2;
                });
                Navigator.of(context).pop();
              },
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: buildBody,
            ),
            // buildBody[
            //     _selectedIndex], //จะไม่ค้างอยู่หน้าปัจจุบัน เวลากดปุ่มเมนูกลับมา

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
                if (_navbarNotifier._index == value) {
                  _navbarNotifier.popAllRoutes(value);
                } else {
                  _navbarNotifier._index = value;
                }
                setState(() => _selectedIndex = value);
              },
            ),
          ),
          loading ? Loading() : Container()
        ],
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
          homeKey.currentState?.popAndPushNamed('/');
        }
        return;
      case 1:
        if (messageKey.currentState != null &&
            messageKey.currentState!.canPop()) {
          messageKey.currentState!.popUntil((route) => route.isFirst);
        }
        if (_selectedIndex == 1) {
          messageKey.currentState;
        }
        return;
      case 2:
        if (profileKey.currentState != null &&
            profileKey.currentState!.canPop()) {
          profileKey.currentState!.popUntil((route) => route.isFirst);
        } else if (_selectedIndex == 2) {
          profileKey.currentState?.popAndPushNamed('/');
        }
        return;
      default:
        break;
    }
  }
}
