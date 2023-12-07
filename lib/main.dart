// ignore_for_file: constant_identifier_names, prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'dart:io';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/language/translation.dart';
import 'package:doormster/screen/main_screen/auth_page.dart';
import 'package:doormster/screen/main_screen/home_page.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:doormster/screen/main_screen/change_password_page.dart';
import 'package:doormster/screen/main_screen/login_staff_page.dart';
import 'package:doormster/screen/main_screen/settings_page.dart';
import 'package:doormster/screen/management_service/management_service_page.dart';
import 'package:doormster/service/notify/notify_service.dart';
import 'package:doormster/style/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doormster/screen/parcel_service/parcel_service_page.dart';
import 'package:doormster/screen/qr_smart_access/qr_smart_home_page.dart';
import 'package:doormster/screen/security_guard/security_guard_page.dart';
import 'package:doormster/screen/visitor_service/visitor_service_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().notification();
  // FlutterNativeSplash.preserve(
  //     widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  FlutterNativeSplash.remove();
  final result = await Connectivity().checkConnectivity();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final language = prefs.getString('language');
  if (language == null) {
    await prefs.setString("language", 'th');
  }
  print(token == null ? 'login : false' : 'login : true');
  print('language : $language');
  runApp(MyApp(
    connect: result,
    token: token,
    language: language,
  ));
}

class MyApp extends StatelessWidget {
  final token;
  final language;
  final connect;
  MyApp({Key? key, this.token, this.language, this.connect}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(
          builder: (context, child) => myTextScale(
              context,
              myScrollScreen(
                context,
                child,
              ))),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('th', 'TH'),
      ],
      locale: language == null ? Locale('th', 'TH') : Locale(language),
      translations: Languages(),
      title: 'HIP Smart Community',
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      // home: token == null ? Login_Page() : BottomBar(),
      initialRoute: connect == ConnectivityResult.none
          ? '/check'
          : token == null
              ? '/auth'
              : '/bottom',
      routes: {
        '/check': (context) => Check_Connected(),
        '/auth': (context) => Auth_Page(),
        '/login': (context) => Login_Page(),
        '/staff': (context) => Login_Staff(),
        '/home': (context) => Home_Page(),
        '/bottom': (context) => BottomBar(),
        '/qrsmart': (context) => QRSmart_HomePage(),
        '/parcel': (context) => Parcel_service(),
        '/management': (context) => Management_Service(),
        '/security': (context) => Security_Guard(),
        '/visitor': (context) => Visitor_Service(),
        '/password': (context) => Password_Page(),
        '/setting': (context) => Settings_Page(),
      },
    );
  }
}

class Check_Connected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
        backgroundColor: const Color(0xFF0B4D9C),
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
                    'found_error'.tr,
                    'connect_fail'.tr,
                    Icons.warning_amber_rounded,
                    Colors.orange,
                    'ok'.tr, () async {
                  if (Platform.isAndroid) {
                    Restart.restartApp();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
