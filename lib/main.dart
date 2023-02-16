import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/reset_password_page.dart';
import 'package:doormster/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doormster/screen/managemant_service/managemant_service_page.dart';
import 'package:doormster/screen/parcel_service/parcel_service_page.dart';
import 'package:doormster/screen/qr_smart_access/qr_smart_home_page.dart';
import 'package:doormster/screen/security_guard/security_guard_page.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  await init(null);
  WidgetsFlutterBinding.ensureInitialized();
  final result = await Connectivity().checkConnectivity();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  print(token == null ? 'login : false' : 'login : true');
  runApp(MyApp(
    // token: null,
    token: token,
  ));
}

Future init(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 1));
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final token;
  MyApp({Key? key, this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HIP Smart Community',
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      // home: token == null ? Login_Page() : BottomBar(),
      initialRoute: token == null ? '/login' : '/bottom',
      routes: {
        '/login': (context) => Login_Page(),
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
