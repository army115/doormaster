// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/girdManu/menu_home.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/models/get_ads_company.dart';
import 'package:doormster/models/get_menu.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
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

class _Home_PageState extends State<Home_Page> {
  var mobileRole;
  var companyId;
  List<DataMenu> listMenu = [];
  List<Data> listads = [];
  bool loading = false;
  var checkNet;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _subscription;

  List<String> _images = [
    'https://resize.indiatvnews.com/en/resize/newbucket/715_-/2020/09/breakingnews-live-blog-1568185450-1595123397-1600221127.jpg',
    'https://s.abcnews.com/images/US/abc_news_default_2000x2000_update_16x9_992.jpg',
    'https://www.vuelio.com/uk/wp-content/uploads/2019/02/Breaking-News.jpg',
    'https://imgeng.jagran.com/images/2022/aug/breaking-news-21660790286781.jpg',
  ];
  List<String> _image = [
    'assets/images/Smart Community Logo.png',
    'assets/images/ads.png',
    'assets/images/HIP Smart Community Icon-01.png',
    'assets/images/HIP Smart Community Icon-02.png',
  ];

  Future _getMenu() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileRole = prefs.getInt('role') ?? "";
    companyId = prefs.getString('companyId');

    print('mobileRole: ${mobileRole}');
    print('companyId: ${companyId}');

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
          loading ? Loading() : _getMenu();
        });
      }, false, false);
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> checkInternet() async {
    checkNet = await Connectivity().checkConnectivity();
  }

  @override
  void initState() {
    super.initState();
    checkInternet();
    _getMenu();
    _subscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
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
      }
    });
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
          body: checkNet == ConnectivityResult.none || loading == true
              ? Container()
              : SingleChildScrollView(
                  child: SafeArea(
                    child: mobileRole == 0 || listMenu.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'โปรดติดต่อผู้ดูแล\nเพื่ออนุมัติสิทธิ์การใช้งาน',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.normal),
                                ),
                                Image.asset(
                                  'assets/images/Smart Community Logo.png',
                                  scale: 4.5,
                                  // opacity: AlwaysStoppedAnimation(0.7),
                                ),
                              ],
                            ),
                          )
                        : Column(
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
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
                                      icon: '${listMenu[index].icon}',
                                      press: listMenu[index].page,
                                    );
                                  },
                                ),
                              ),
                              // SizedBox(height: 20),
                              // Buttons(
                              //     title: 'test',
                              //     press: () {
                              //       dialogOnebutton_Subtitle(
                              //           context,
                              //           'พบข้อผิดพลาด',
                              //           'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
                              //           Icons.warning_amber_rounded,
                              //           Colors.orange,
                              //           'ตกลง', () {
                              //         Navigator.of(context, rootNavigator: true)
                              //             .pop();
                              //       }, false, false);
                              //     })
                            ],
                          ),
                  ),
                ),
        ),
        loading ? Loading() : Container(),
      ],
    );
  }
}
