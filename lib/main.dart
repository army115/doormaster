import 'dart:async';

import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/screen/main_screen/auth_page.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/change_password_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doormster/screen/managemant_service/managemant_service_page.dart';
import 'package:doormster/screen/parcel_service/parcel_service_page.dart';
import 'package:doormster/screen/qr_smart_access/qr_smart_home_page.dart';
import 'package:doormster/screen/security_guard/security_guard_page.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(
  //     widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  final result = await Connectivity().checkConnectivity();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  print(token == null ? 'login : false' : 'login : true');
  FlutterNativeSplash.remove();
  runApp(result == ConnectivityResult.none
      ? Check_Connected()
      : MyApp(
          // token: null,
          token: token,
        ));
}

class MyApp extends StatelessWidget {
  final token;
  MyApp({Key? key, this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      title: 'HIP Smart Community',
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      // home: token == null ? Login_Page() : BottomBar(),
      initialRoute: token == null ? '/auth' : '/bottom',
      routes: {
        '/auth': (context) => Auth_Page(),
        '/login': (context) => Login_Page(),
        '/staff': (context) => Login_Staff(),
        '/home': (context) => Home_Page(),
        '/bottom': (context) => BottomBar(),
        '/qrsmart': (context) => QRSmart_HomePage(),
        '/parcel': (context) => Parcel_service(),
        '/managemant': (context) => Managemant_Service(),
        '/security': (context) => Security_Guard(),
        '/visitor': (context) => Visitor_Service(),
        '/password': (context) => Password_Page(),
      },
    );
  }
}

class Check_Connected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HIP Smart Community',
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      home: WillPopScope(
        onWillPop: (() async => false),
        child: Scaffold(
          backgroundColor: Color(0xFF0B4D9C),
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/images/HIP Smart Community Icon-03.png',
                          scale: 4,
                        ),
                      ),
                      Image.asset(
                        'assets/images/banner.png',
                        scale: 4,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: double.infinity,
                  color: Colors.black38,
                  child: dialogmain(
                      'พบข้อผิดพลาด',
                      'ไม่สามารถเชื่อมต่อได้ กรุณาลองใหม่อีกครั้ง',
                      Icons.warning_amber_rounded,
                      Colors.orange,
                      'ตกลง', () {
                    Restart.restartApp();
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
