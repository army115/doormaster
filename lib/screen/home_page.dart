// ignore_for_file: prefer_const_constructors

import 'package:card_swiper/card_swiper.dart';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/girdManu/gird_menu.dart';
import 'package:doormster/components/girdManu/menu_home.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/models/menu_model.dart';
import 'package:doormster/screen/qr_smart_access/opendoor_page.dart';
import 'package:doormster/screen/qr_smart_access/scan_qrcode_page.dart';
import 'package:doormster/screen/qr_smart_access/visitor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Home_Page extends StatefulWidget {
  Home_Page({
    Key? key,
  }) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
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

  bool loading = false;

  var mobileRole;
  Future _getRole() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileRole = await prefs.getInt('role') ?? "";
    print('mobileRole: ${mobileRole}');
    setState(() {
      loading = false;
    });
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      checkInternet(Opendoor_Page());
    } else {
      dialogOnebutton_Subtitle(
        context,
        'อนุญาตการเข้าถึง',
        'จำเป็นต้องอนุญาตการเข้าถึงตำแหน่งของคุณ',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง',
        () {
          openAppSettings();
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getRole();
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
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            child: Image.network(
                                'https://media.istockphoto.com/id/1186036259/vector/tv-news-studio-breaking-news-background-with-anchorman-or-presenter-television-program.jpg?s=612x612&w=0&k=20&c=Ai47mIuGqfWAILiL-SJCKBUjVEgE3Bk9itlszQ3GCz8='));
                      },
                      // ),
                      itemCount: 1,
                      scale: 1.0,
                      pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                              activeColor: Colors.black)),
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
                        itemCount: Menu.length,
                        itemBuilder: (context, index) {
                          return Menu_Home(
                            title: '${Menu[index].name}',
                            icon: IconData(Menu[index].icons,
                                fontFamily: 'MaterialIcons'),
                            press: Menu[index].page,
                          );
                        },
                        // children: [
                        //   Gird_Menu(
                        //     title: 'ผู้มาติดต่อ',
                        //     icon: Icons.person,
                        //     press: () {
                        //       checkInternet(Visitor_Page());
                        //     },
                        //   ),
                        //   Gird_Menu(
                        //     title: 'สแกน',
                        //     icon: Icons.qr_code_scanner_rounded,
                        //     press: () {
                        //       checkInternet(Scanner());
                        //     },
                        //   ),
                        //   Gird_Menu(
                        //     title: 'เปิดประตู',
                        //     icon: Icons.meeting_room_rounded,
                        //     press: () {
                        //       requestLocationPermission();
                        //     },
                        //   ),
                        //   Gird_Menu(
                        //       title: 'Emergency Call',
                        //       icon: Icons.phone_forwarded_rounded,
                        //       press: () async {
                        //         await FlutterPhoneDirectCaller.callNumber(
                        //             '0123456789');
                        //       }),
                        // ],
                      ),
                    ),
                  ),
                  // SizedBox(height: 20),
                  // Buttons(
                  //     title: 'test',
                  //     press: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: ((context) => Test())));
                  //     })
                ],
              ),
            ),
    );
  }
}
