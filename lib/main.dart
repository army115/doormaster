// ignore_for_file: constant_identifier_names, prefer_const_constructors, prefer_const_constructors_in_immutables, avoid_print, prefer_typing_uninitialized_variables
import 'dart:developer';

import 'package:doormster/controller/main_controller/login_controller.dart';
import 'package:doormster/language/translation.dart';
import 'package:doormster/routes/page/pages_routes.dart';
import 'package:doormster/routes/paths/paths_routes.dart';
import 'package:doormster/service/notify/notify_service.dart';
import 'package:doormster/style/scroll_screen.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:doormster/style/theme/dark/theme_dark.dart';
import 'package:doormster/style/theme/light/theme_light.dart';
import 'package:doormster/utils/secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.remove();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final List<ConnectivityResult> result =
      await Connectivity().checkConnectivity();

  if (result.contains(ConnectivityResult.none)) {
  } else {
    await NotificationService().initializeNotification();
  }

  String? getlanguage = await SecureStorageUtils.readString('language');
  if (getlanguage == null) {
    await SecureStorageUtils.writeString("language", 'th');
  }

  final token = await SecureStorageUtils.readString('token');
  final language = await SecureStorageUtils.readString('language');
  final theme = await SecureStorageUtils.readBool('theme');

  final LoginController loginController = Get.put(LoginController());
  if (token != null) {
    loginController.refreshToken();
  }
  debugPrint(token == null ? 'login : false' : 'login : true');
  debugPrint('language : $language');
  debugPrint('theme : $theme');
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
  MyApp({super.key, this.token, this.language, this.connect, this.theme});
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
      defaultTransition: Transition.fadeIn,
      themeMode: theme != null
          ? theme
              ? ThemeMode.dark
              : ThemeMode.light
          : ThemeMode.system,
      theme: themeLight,
      darkTheme: themeDark,
      initialRoute: connect.contains(ConnectivityResult.none)
          ? Routes.check
          : token == null
              ? Routes.login_user
              : Routes.bottom,
      getPages: PagesRoutes.routes,
    );
  }
}
