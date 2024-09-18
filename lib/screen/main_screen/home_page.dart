// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field, non_constant_identifier_names
import 'dart:async';
import 'package:doormster/components/girdManu/menu_home.dart';
import 'package:doormster/components/girdManu/menu_security.dart';
import 'package:doormster/components/list_null_opacity/icon_opacity.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/controller/branch_controller.dart';
import 'package:doormster/controller/home_controller.dart';
import 'package:doormster/controller/profile_controller.dart';
import 'package:doormster/models/main_models/get_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert' as convert;

class Home_Page extends StatefulWidget {
  Home_Page({
    Key? key,
  }) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page>
    with AutomaticKeepAliveClientMixin {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      profileController.get_Profile(loadingTime: 0).then(
            (value) => branchController.get_Branch(),
          );
    });
    // _subscription =
    //     _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    //   if (result == ConnectivityResult.none) {
    //     dialogOnebutton_Subtitle(
    //         context,
    //         'พบข้อผิดพลาด',
    //         'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
    //         Icons.warning_amber_rounded,
    //         Colors.orange,
    //         'ตกลง', () {
    //       Navigator.of(context, rootNavigator: true).pop();
    //       setState(() {
    //         _getMenu();
    //       });
    //     }, false, false);
    //   }
    //   log("result $result");
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() => Stack(
          children: [
            Scaffold(
                appBar: AppBar(
                  title: Text('HIP Smart Community'),
                  leading: IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      }),
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    // get_Info();
                    // Homecontroller.GetMenu();
                  },
                  child:
                      // Homecontroller.loading.isTrue ||
                      //         Homecontroller.mobileRole == null
                      //     ? Container()
                      //     : Homecontroller.security == true
                      //         ? Security()
                      //         :
                      normalUser(),
                )),
            Homecontroller.loading.isTrue ? Loading() : Container(),
          ],
        ));
  }

  Widget normalUser() {
    getMenu getmenu = getMenu.fromJson(dataMenu);
    List<DataMenu> listMenu = getmenu.data!;

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          SizedBox(
              height: Get.mediaQuery.size.width * 0.6,
              width: double.infinity,
              child: Homecontroller.listAds.isEmpty
                  ? Swiper(
                      autoplay: false,
                      loop: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          'assets/images/ads.png',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Swiper(
                      autoplay:
                          Homecontroller.listAds.length == 1 ? false : true,
                      loop: Homecontroller.listAds.length == 1 ? false : true,
                      physics: Homecontroller.listAds.length == 1
                          ? NeverScrollableScrollPhysics()
                          : ClampingScrollPhysics(),
                      pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                              size: 8,
                              activeSize: 8,
                              color: Colors.grey,
                              activeColor: Colors.white)),
                      itemCount: Homecontroller.listAds.length,
                      itemBuilder: (context, index) {
                        var _Images = convert.base64Decode(
                            ('${Homecontroller.listAds[index].adsversitingPic}')
                                .split(',')
                                .last);
                        return InkWell(
                            // onTap: () {
                            //   launchUrlString('https://hipglobal.co.th/');
                            // },
                            child: Image.memory(
                          _Images,
                          fit: BoxFit.cover,
                        ));
                      },
                    )),
          Container(
            child: listMenu.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Get.mediaQuery.size.height * 0.13),
                    child: Icon_Opacity(title: 'contact_admin_manu'.tr),
                  )
                : Container(
                    padding: EdgeInsets.fromLTRB(
                        20, 20, 20, Get.mediaQuery.size.width * 0.15),
                    child: GridView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      primary: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // childAspectRatio: 0.65,
                          crossAxisCount: 4,
                          crossAxisSpacing: 20,
                          // mainAxisSpacing: 5,
                          mainAxisExtent: 120),
                      itemCount: listMenu.length,
                      itemBuilder: (context, index) {
                        return Menu_Home(
                          title: '${listMenu[index].name}',
                          icon: listMenu[index].icon,
                          press: listMenu[index].page,
                          type: '${listMenu[index].type}',
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget Security() {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
        children: [
          SizedBox(
            height: Get.mediaQuery.size.width * 0.6,
            width: double.infinity,
            child: Homecontroller.listAds.isNotEmpty
                ? Swiper(
                    autoplay: true,
                    loop: true,
                    pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                            color: Colors.grey, activeColor: Colors.white)),
                    itemCount: Homecontroller.listAds.length,
                    itemBuilder: (context, index) {
                      var _Images = convert.base64Decode(
                          ('${Homecontroller.listAds[index].adsversitingPic}')
                              .split(',')
                              .last);
                      return InkWell(
                          // onTap: () {
                          //   launchUrlString(
                          //       'https://hipglobal.co.th/');
                          // },
                          // child: Container(
                          //     child:
                          //         Image.network('${_images[index]}')),
                          child: Image.memory(
                        _Images,
                        fit: BoxFit.cover,
                      ));
                    },
                  )
                : Swiper(
                    autoplay: true,
                    loop: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        'assets/images/ads.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: GridView.count(
              shrinkWrap: true,
              primary: false,
              childAspectRatio: 0.65,
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 5,
              children: [
                Menu_Security(
                    title: 'security', press: '/security', icon: Icons.man),
                Menu_Security(
                    title: 'visitor', press: '/visitor', icon: Icons.boy)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic> dataMenu = {
  "status": 200,
  "data": [
    {
      "_id": "6409606bf97bd54444efbc63",
      "icon": "0xf78c",
      "name": "QR Smart",
      "page": "/qrsmart",
      "company_id": "6409606bf97bd54444efbc57",
      "modulename": "qrsmartAccess",
      "type": "cuper"
    },
    {
      "_id": "6461b90259a06334fa0fb909",
      "icon": "0xf61c",
      "name": "Parcel",
      "page": "/parcel",
      "company_id": "6409606bf97bd54444efbc57",
      "modulename": "Parcel",
      "type": "cuper"
    },
    {
      "_id": "6461b92559a06334fa0fb90c",
      "icon": "0xf89e",
      "name": "Management",
      "page": "/management",
      "company_id": "6409606bf97bd54444efbc57",
      "modulename": "Management",
      "type": "normal"
    },
    {
      "_id": "6461ba9359a06334fa0fb90e",
      "icon": "0xf02e2",
      "name": "Visitor",
      "page": "/visitor",
      "company_id": "6409606bf97bd54444efbc57",
      "modulename": "Visitor",
      "type": "normal"
    },
    {
      "_id": "64759f2383ea8daab8170cc1",
      "icon": "0xf0630",
      "name": "Security",
      "page": "/security",
      "company_id": "6409606bf97bd54444efbc57",
      "modulename": "Security",
      "type": "normal"
    }
  ]
};
