// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api

import 'package:doormster/components/bottombar/bottom_controller.dart';
import 'package:doormster/components/button/button_theme.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/routes/menu/home_menu.dart';
import 'package:doormster/routes/menu/news_menu.dart';
import 'package:doormster/routes/menu/notification_menu.dart';
import 'package:doormster/routes/menu/profile_menu.dart';
import 'package:doormster/screen/main_screen/news_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> newsKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> notifyKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();

class BottomBar extends StatefulWidget {
  BottomBar({
    Key? key,
  });

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
// with SingleTickerProviderStateMixin
{
  final buildBody = [
    Home_Menu(),
    News_Page(),
    Notification_Menu(),
    Profile_Menu(),
  ];

  // final Buttontheme controller = Get.put(Buttontheme());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => bottomController.onBackButtonDoubleClicked(context),
      child: Obx(() => Scaffold(
            drawerEnableOpenDragGesture: false,
            key: scaffoldKey,
            drawer: MyDrawer(),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: bottomController.tabController,
              children: buildBody,
            ),
            //     IndexedStack(
            //   index: bottomController.tabController.index,
            //   children: buildBody,
            // ),
            // buildBody[bottomController.tabController
            //     .index], //จะไม่ค้างอยู่หน้าปัจจุบัน เวลากดปุ่มเมนูกลับมา
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: bottomController.selectedIndex.value,
              onTap: bottomController.ontapItem,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'home'.tr,
                  activeIcon: Icon(Icons.home_rounded),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined),
                  activeIcon: Icon(Icons.newspaper_rounded),
                  label: 'news'.tr,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none_rounded),
                  activeIcon: Icon(Icons.notifications_rounded),
                  label: 'notification'.tr,
                ),
                BottomNavigationBarItem(
                  activeIcon: Icon(Icons.account_circle_rounded),
                  icon: Icon(Icons.account_circle_outlined),
                  label: 'profile'.tr,
                ),
              ],
            ),
          )),
    );
  }
}
