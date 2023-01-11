import 'package:doormster/components/button/button.dart';
import 'package:doormster/components/girdManu/gird_menu.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/screen/login_page.dart';
import 'package:doormster/screen/test.dart';
import 'package:doormster/screen/visitor_page.dart';
import 'package:doormster/screen/opendoor_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Home_Page extends StatefulWidget {
  Home_Page({
    Key? key,
  }) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  Future _Logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => Login_Page()),
        (Route<dynamic> route) => false);
    print('logout success');
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

  bool loading = false;

  var mobileRole;
  Future _getRole() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileRole = await prefs.getInt('role');
    print('mobileRole: ${mobileRole}');
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRole();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หน้าแรก'), actions: [
        IconButton(
            onPressed: () {
              _Logout();
            },
            icon: Icon(Icons.power_settings_new_rounded))
      ]),
      body: mobileRole == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'โปรดติดต่อผู้ดูแล\nเพื่ออนุมัติสิทธิ์การใช้งาน',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
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
                        title: 'เปิดประตู',
                        icon: Icons.login_rounded,
                        press: () {
                          checkInternet(Opendoor_Page());
                        },
                      ),
                      Gird_Menu(
                          title: 'Call Guard',
                          icon: Icons.phone_forwarded_rounded,
                          press: () async {
                            await FlutterPhoneDirectCaller.callNumber(
                                '0123456789');
                          }),
                      Gird_Menu(
                        title: 'Call Reception/นิติบุคคล',
                        icon: Icons.contact_phone_rounded,
                        press: () {
                          launch('tel:0123456789');
                        },
                      ),
                    ],
                  ),
                  Buttons(
                      title: 'test',
                      press: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) => Test())));
                      })
                ]),
              ),
            )),
    );
  }
}
