import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/girdManu/gird_menu.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/screen/qr_smart_access/opendoor_page.dart';
import 'package:doormster/screen/qr_smart_access/scan_qrcode_page.dart';
import 'package:doormster/screen/qr_smart_access/visitor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class QRSmart_HomePage extends StatefulWidget {
  const QRSmart_HomePage({
    Key? key,
  }) : super(key: key);
  static const String route = '/qrsmart';

  @override
  State<QRSmart_HomePage> createState() => _QRSmart_HomePageState();
}

class _QRSmart_HomePageState extends State<QRSmart_HomePage> {
  void checkInternet(page) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => page,
      ));
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
    if (status.isDenied) {
      dialogOnebutton_Subtitle(
        context,
        'อนุญาตการเข้าถึง',
        'จำเป็นต้องเข้าถึงตำแหน่งของคุณ',
        Icons.warning_amber_rounded,
        Colors.orange,
        'ตกลง',
        () {
          openAppSettings();
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
    } else {
      checkInternet(Opendoor_Page());
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
      drawer: MyDrawer(),
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
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(30),
                child: Column(children: [
                  GridView.count(
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    primary: false,
                    childAspectRatio: 1.0,
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      Gird_Menu(
                        title: 'ผู้มาติดต่อ',
                        icon: Icons.person,
                        press: () {
                          checkInternet(Visitor_Page());
                        },
                      ),
                      Gird_Menu(
                        title: 'สแกน',
                        icon: Icons.qr_code_scanner_rounded,
                        press: () {
                          checkInternet(Scanner());
                        },
                      ),
                      Gird_Menu(
                        title: 'เปิดประตู',
                        icon: Icons.meeting_room_rounded,
                        press: () {
                          requestLocationPermission();
                        },
                      ),
                      Gird_Menu(
                          title: 'Emergency Call',
                          icon: Icons.phone_forwarded_rounded,
                          press: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                '0123456789');
                          }),
                    ],
                  ),
                  // SizedBox(height: 20),
                  // Buttons(
                  //     title: 'test',
                  //     press: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: ((context) => Test())));
                  //     })
                ]),
              ),
            ),
    );
  }
}
