import 'package:doormster/screen/home_page.dart';
import 'package:doormster/screen/login_page.dart';
import 'package:doormster/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  print(token == null ? 'login : false' : 'login : true');
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp(
    // token: null,
    token: token,
  ));
}

class MyApp extends StatelessWidget {
  final token;
  MyApp({Key? key, this.token}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mytheme(),
      home: token == null ? Login_Page() : Home_Page(),
    );
  }
}
