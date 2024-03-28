// ignore_for_file: constant_identifier_names, prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'dart:io';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/language/translation.dart';
import 'package:doormster/routes/page/pages_routes.dart';
import 'package:doormster/service/notify/notify_service.dart';
import 'package:doormster/style/scroll_screen.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:doormster/style/theme/dark/theme_dark.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().notification();
  FlutterNativeSplash.remove();
  final result = await Connectivity().checkConnectivity();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final language = prefs.getString('language');
  final theme = prefs.getBool('theme');
  print(token == null ? 'login : false' : 'login : true');
  print('language : $language');
  print('theme : $theme');
  runApp(MyApp(
    connect: result,
    token: token,
    language: language,
    theme: theme,
  ));
}

class MyApp extends StatelessWidget {
  final token;
  final language;
  final connect;
  final theme;
  MyApp({Key? key, this.token, this.language, this.connect, this.theme})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(
          builder: (context, child) => myTextScale(
              context,
              myScrollScreen(
                child!,
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
      themeMode: theme != null
          ? theme
              ? ThemeMode.dark
              : ThemeMode.light
          : ThemeMode.system,
      theme: themeLight,
      darkTheme: themeDark,
      // home: token == null ? Login_Page() : BottomBar(),
      initialRoute: connect == ConnectivityResult.none
          ? '/check'.tr
          : token == null
              ? '/auth'.tr
              : '/bottom'.tr,
      routes: pages_routes,
    );
  }
}

class Check_Connected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async => false),
      child: Scaffold(
        backgroundColor: Get.theme.primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/Smart Logo White.png',
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
