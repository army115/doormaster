// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, unused_field, non_constant_identifier_names
import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/actions/disconnected_dialog.dart';
import 'package:doormster/components/girdManu/menu_home.dart';
import 'package:doormster/components/girdManu/menu_security.dart';
import 'package:doormster/components/list_null_opacity/icon_opacity.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/controller/home_controller.dart';
import 'package:doormster/models/get_ads_company.dart';
import 'package:doormster/models/get_menu.dart';
import 'package:doormster/controller/get_info.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final HomeController controller = Get.put(HomeController());

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _subscription;

  // Future _getMenu() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   mobileRole = prefs.getInt('role') ?? 0;
  //   companyId = prefs.getString('companyId');
  //   security = prefs.getBool('security');
  //   checkNet = await Connectivity().checkConnectivity();

  //   log('net $checkNet');
  //   print('mobileRole: ${mobileRole}');
  //   print('companyId: ${companyId}');
  //   print('security: ${security}');
  //   try {
  //     setState(() {
  //       loading = true;
  //     });

  //     // await Future.delayed(Duration(milliseconds: 300));

  //     //call api manu
  //     var url = '${Connect_api().domain}/get/menumobile/$companyId';
  //     var response = await Dio().get(
  //       url,
  //       options: Options(headers: {
  //         'Connect-type': 'application/json',
  //         'Accept': 'application/json',
  //       }),
  //     );

  //     //call api ads
  //     var urlAds = '${Connect_api().domain}/get/ads/$companyId';
  //     var responseAds = await Dio().get(
  //       urlAds,
  //       options: Options(headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       }),
  //     );

  //     if (response.statusCode == 200 && responseAds.statusCode == 200) {
  //       // getMenu menuHome = getMenu.fromJson(response.data);
  //       // getAdsCompany asdcompany = getAdsCompany.fromJson(responseAds.data);
  //       listMenu.assignAll(getMenu.fromJson(response.data).data!);
  //       listads.assignAll(getAdsCompany.fromJson(responseAds.data).data!);
  //       setState(() {
  //         // listMenu = menuHome.data!;
  //         // listads = asdcompany.data!;
  //         loading = false;
  //       });
  //     }
  //   } catch (error) {
  //     print(error);
  //     // await Future.delayed(Duration(milliseconds: 500));
  //     error_connected(context, () {
  //       Navigator.of(context, rootNavigator: true).pop();
  //       setState(() {
  //         _getMenu();
  //       });
  //     });
  //     setState(() {
  //       loading = false;
  //     });
  //   }
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    get_Info();
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

  Future onGoBack(dynamic value) async {
    setState(() {
      get_Info();
    });
  }

  // @override
  // void dispose() {
  //   _subscription?.cancel();
  //   super.dispose();
  // }

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
              body:

                  // controller.checkNet == ConnectivityResult.none ||
                  controller.loading.isTrue || controller.mobileRole == null
                      ? Container()
                      : controller.security == true
                          ? Security()
                          : normalUser(),
            ),
            controller.loading.isTrue ? Loading() : Container(),
          ],
        ));
  }

  Widget normalUser() {
    return controller.mobileRole == 0
        ? Logo_Opacity(title: 'contact_admin_approve'.tr)
        : Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: double.infinity,
                  child: controller.listAds.isEmpty
                      ? Swiper(
                          autoplay: false,
                          loop: false,
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
                              controller.listAds.length == 1 ? false : true,
                          loop: controller.listAds.length == 1 ? false : true,
                          pagination: SwiperPagination(
                              builder: DotSwiperPaginationBuilder(
                                  size: 8,
                                  activeSize: 8,
                                  color: Colors.grey,
                                  activeColor: Colors.white)),
                          itemCount: controller.listAds.length,
                          itemBuilder: (context, index) {
                            var _Images = convert.base64Decode(
                                ('${controller.listAds[index].adsversitingPic}')
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
              RefreshIndicator(
                onRefresh: () async {
                  get_Info();
                  controller.GetMenu();
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: controller.listMenu.isEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                vertical:
                                    MediaQuery.of(context).size.height * 0.13),
                            child: Icon_Opacity(title: 'contact_admin_manu'.tr),
                          )
                        : Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20,
                                MediaQuery.of(context).size.width * 0.15),
                            child: GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      // childAspectRatio: 0.65,
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 30,
                                      // mainAxisSpacing: 5,
                                      mainAxisExtent: 120),
                              itemCount: controller.listMenu.length,
                              itemBuilder: (context, index) {
                                return Menu_Home(
                                  title: '${controller.listMenu[index].name}',
                                  icon: controller.listMenu[index].icon,
                                  press: controller.listMenu[index].page,
                                  type: '${controller.listMenu[index].type}',
                                  goBack: onGoBack,
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget Security() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: double.infinity,
          child: controller.listAds.isNotEmpty
              ? Swiper(
                  autoplay: true,
                  loop: true,
                  pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                          color: Colors.grey, activeColor: Colors.white)),
                  itemCount: controller.listAds.length,
                  itemBuilder: (context, index) {
                    var _Images = convert.base64Decode(
                        ('${controller.listAds[index].adsversitingPic}')
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
        RefreshIndicator(
          onRefresh: () async {
            get_Info();
            controller.GetMenu();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
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
          ),
        ),
      ],
    );
  }
}
