// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/girdManu/menu_home.dart';
import 'package:doormster/components/girdManu/menu_security.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/models/get_ads_company.dart';
import 'package:doormster/models/get_menu.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:convert' as convert;

import 'package:url_launcher/url_launcher_string.dart';

class Home_Page extends StatefulWidget {
  Home_Page({
    Key? key,
  }) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  var mobileRole;
  var companyId;
  var security;
  List<DataMenu> listMenu = [];
  List<Data> listads = [];
  bool loading = false;
  var checkNet;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _subscription;

  Future _getMenu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileRole = prefs.getInt('role') ?? "";
    companyId = prefs.getString('companyId');
    security = prefs.getBool('security');

    print('mobileRole: ${mobileRole}');
    print('companyId: ${companyId}');
    print('security: ${security}');
    try {
      setState(() {
        loading = true;
      });

      //call api manu
      var url = '${Connect_api().domain}/get/menumobile/$companyId';
      var response = await Dio().get(
        url,
        options: Options(headers: {
          'Connect-type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      //call api ads
      var urlAds = '${Connect_api().domain}/get/ads/$companyId';
      var responseAds = await Dio().get(
        urlAds,
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      if (response.statusCode == 200 && responseAds.statusCode == 200) {
        getMenu menuHome = getMenu.fromJson(response.data);

        getAdsCompany asdcompany = getAdsCompany.fromJson(responseAds.data);
        setState(() {
          listMenu = menuHome.data!;
          listads = asdcompany.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      await Future.delayed(Duration(milliseconds: 500));
      dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง', () {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _getMenu();
        });
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> checkInternet() async {
    checkNet = await Connectivity().checkConnectivity();
    log('net $checkNet');
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
    _getMenu();
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
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            body: SafeArea(
              child: checkNet == ConnectivityResult.none || loading
                  ? Container()
                  : security == true
                      ? Security()
                      : normalUser(),
            )),
        loading ? Loading() : Container(),
      ],
    );
  }

  Widget normalUser() {
    return SafeArea(
      child: mobileRole == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'โปรดติดต่อผู้ดูแล\nเพื่ออนุมัติสิทธิ์การใช้งาน',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.normal),
                  ),
                  Image.asset(
                    'assets/images/Smart Community Logo.png',
                    scale: 4.5,
                    // opacity: AlwaysStoppedAnimation(0.7),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.6,
                    width: double.infinity,
                    child: listads.length > 0
                        ? Swiper(
                            autoplay: true,
                            loop: true,
                            pagination: SwiperPagination(
                                builder: DotSwiperPaginationBuilder(
                                    size: 8,
                                    activeSize: 8,
                                    color: Colors.grey,
                                    activeColor: Colors.white)),
                            itemCount: listads.length,
                            itemBuilder: (context, index) {
                              var _Images = convert.base64Decode(
                                  ('${listads[index].adsversitingPic}')
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
                  listMenu.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.orange,
                                  size: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'ไม่มีเมนูที่คุณใช้งานได้\nโปรดติดต่อผู้ดูแล',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                                // Image.asset(
                                //   'assets/images/Smart Community Logo.png',
                                //   scale: 4.5,
                                //   // opacity: AlwaysStoppedAnimation(0.7),
                                // ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 0.65,
                              crossAxisCount: 4,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 5,
                            ),
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
                ],
              ),
            ),
    );
  }

  Widget Security() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: double.infinity,
              child: listads.length > 0
                  ? Swiper(
                      autoplay: true,
                      loop: true,
                      pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                              color: Colors.grey, activeColor: Colors.white)),
                      itemCount: listads.length,
                      itemBuilder: (context, index) {
                        var _Images = convert.base64Decode(
                            ('${listads[index].adsversitingPic}')
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
            )
          ],
        ),
      ),
    );
  }
}
