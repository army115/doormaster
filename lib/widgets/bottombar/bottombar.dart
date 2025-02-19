// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api
import 'package:doormster/utils/secure_storage.dart';
import 'package:doormster/widgets/bottombar/bottom_controller.dart';
import 'package:doormster/widgets/drawer/drawer.dart';
import 'package:doormster/widgets/image/circle_image.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/routes/menu/home_menu.dart';
import 'package:doormster/routes/menu/news_menu.dart';
import 'package:doormster/routes/menu/notification_menu.dart';
import 'package:doormster/routes/menu/profile_menu.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class BottomBar extends StatelessWidget {
  BottomBar({super.key});

  var image;

  final buildBody = [
    Home_Menu(),
    News_Menu(),
    Notification_Menu(),
    // ChatListScreen()
    Profile_Menu(),
  ];

  Future<void> getInfo() async {
    image = await SecureStorageUtils.readString('image');
  }

  @override
  Widget build(BuildContext context) {
    getInfo();
    return WillPopScope(
      onWillPop: () => bottomController.onBackButtonDoubleClicked(context),
      child: Obx(() => Stack(
            children: [
              Scaffold(
                endDrawerEnableOpenDragGesture: false,
                key: scaffoldKey,
                endDrawer: MyDrawer(),
                drawer: MyDrawer(),
                body: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: bottomController.tabController,
                  children: buildBody,
                ),
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
                      icon: bottomController.notificationCount.value > 0
                          ? Badge(
                              label: Text(
                                  '${bottomController.notificationCount.value}'),
                              largeSize: 20,
                              child: Icon(Icons.notifications_none_rounded),
                            )
                          : Icon(Icons.notifications_none_rounded),
                      activeIcon: Icon(Icons.notifications),
                      // Badge(
                      //   label: Text('10'),
                      //   largeSize: 20,
                      //   child: Icon(Icons.notifications),
                      // ),
                      label: 'notification'.tr,
                    ),
                    // BottomNavigationBarItem(
                    //   activeIcon: Icon(Icons.chat_rounded),
                    //   icon: Icon(Icons.chat_outlined),
                    //   label: 'chat'.tr,
                    // ),
                    BottomNavigationBarItem(
                      icon: circleImage(
                        imageProfile: image,
                        radiusCircle: 15,
                        typeImage: 'net',
                        iconImagenull: const Icon(
                          Icons.account_circle_rounded,
                          color: Colors.grey,
                          size: 25,
                        ),
                        iconImageError: const Icon(Icons.error,
                            size: 25, color: Colors.grey),
                      ),
                      // Icon(Icons.account_circle_outlined),
                      label: 'profile'.tr,
                    ),
                  ],
                ),
              ),
              connectApi.loading.isTrue ? Loading() : Container()
            ],
          )),
    );
  }
}
