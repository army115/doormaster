// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/messages_page.dart';
import 'package:doormster/screen/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomBar extends StatefulWidget {
  final page;
  BottomBar({Key? key, this.page});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final _pageOptions = [Home_Page(), Massages_Page(), Profile_Page()];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.page == null ? _selectedIndex : widget.page;
  }

  DateTime backPressedTime = DateTime.now();

  Future<bool> _onBackButtonDoubleClicked() async {
    //difference in time
    final difference = DateTime.now().difference(backPressedTime);
    backPressedTime = DateTime.now();
    if (difference >= const Duration(seconds: 2)) {
      Fluttertoast.showToast(
          msg: "กรุณากดอีกครั้งเพื่อออก",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(context).primaryColor,
          // textColor: Colors.white,
          fontSize: 16.0);

      return false;
    } else {
      SystemNavigator.pop(animated: true);
      return true;
    }
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return Home_Page();
      case 1:
        return Massages_Page();
      case 2:
        return Profile_Page();
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
      //     return Scaffold(
      //       body: _pageOptions[_selectedIndex],
      //     );
      //     CupertinoTabView(
      //       builder: (context) {
      //         return _pageOptions[_selectedIndex];
      //       },
      //     );
      //   },
      // ),
      child: Scaffold(
        drawer: MyDrawer(),
        body: getPage(_selectedIndex),
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
            // Respond to item press.
            setState(() => _selectedIndex = value);
          },
        ),
      ),
    );
  }
}
