import 'dart:async';
import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/screen/main_screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class Splash_Page extends StatefulWidget {
  const Splash_Page({Key? key});

  @override
  State<Splash_Page> createState() => _Splash_PageState();
}

class _Splash_PageState extends State<Splash_Page> {
  var token;

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token == null ? 'login : false' : 'login : true');
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => token == null ? Login_Page() : BottomBar(),
          ));
    }); // MaterialPageRoute
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/HIP Smart Community Icon-03.png',
            scale: 4.5,
          ),
        ],
      )),
    );
  }
}
