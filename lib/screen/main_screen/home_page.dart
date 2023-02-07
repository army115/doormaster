// ignore_for_file: prefer_const_constructors

import 'package:card_swiper/card_swiper.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/girdManu/menu_home.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/get_ads_company.dart';
import 'package:doormster/models/get_menu.dart';
import 'package:doormster/service/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
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

      var url = '${Connect_api().domain}/get/menumobile/$companyId';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        getMenu menuHome = getMenu.fromJson(convert.jsonDecode(response.body));

        setState(() {
          listMenu = menuHome.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      if (companyId == null) {
      } else {
        dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง',
          () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  Future _getAds() async {
    try {
      setState(() {
        loading = true;
      });

      var url = '${Connect_api().domain}/get/ads/$companyId';
      var response = await http.get(Uri.parse(url), headers: {
        'Connect-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        getAdsCompany asdcompany =
            getAdsCompany.fromJson(convert.jsonDecode(response.body));
        setState(() {
          listads = asdcompany.data!;
          loading = false;
        });
      }
    } catch (error) {
      print(error);
      if (companyId == null) {
      } else {
        dialogOnebutton_Subtitle(
          context,
          'พบข้อผิดพลาด',
          'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
          Icons.warning_amber_rounded,
          Colors.orange,
          'ตกลง',
          () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        );
      }
      setState(() {
        loading = false;
      });
    }
  }

  void checkInternet(page) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    } else {
      snackbar(context, Colors.orange, 'กรุณาเชื่อมต่ออินเตอร์เน็ต',
          Icons.warning_amber_rounded);
      print('not connected');
    }
  }

  @override
  void initState() {
    super.initState();
    _getMenu();
    _getAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HIP Smart Community'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: mobileRole == 0
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
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.6,
                    child: Swiper(
                      autoplay: true,
                      loop: true,
                      // fade: 0.0,
                      scale: 1.0,
                      pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                              activeColor: Colors.white)),
                      itemCount: listads.length,
                      itemBuilder: (context, index) {
                        return Container(
                            child: Image.memory(
                          convert.base64Decode(
                              '${listads[index].adsversitingPic}'),
                        ));
                      },
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          // childAspectRatio: 1,
                          crossAxisCount: 4,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: listMenu.length,
                        itemBuilder: (context, index) {
                          return Menu_Home(
                            title: '${listMenu[index].name}',
                            icon: int.parse('${listMenu[index].icon}'),
                            press: listMenu[index].page,
                          );
                        },
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  Buttons(
                      title: 'test',
                      press: () {
                        setState(() {
                          _getMenu();
                        });
                      })
                ],
              ),
            ),
    );
  }
}
