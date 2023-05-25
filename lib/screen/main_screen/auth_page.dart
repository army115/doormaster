import 'package:doormster/components/snackbar/back_double.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Auth_Page extends StatefulWidget {
  Auth_Page({Key? key});

  @override
  State<Auth_Page> createState() => _Auth_PageState();
}

class _Auth_PageState extends State<Auth_Page> {
  DateTime PressTime = DateTime.now();

  Future<bool> _onBackButtonDoubleClicked() async {
    int difference = DateTime.now().difference(PressTime).inMilliseconds;
    PressTime = DateTime.now();
    if (difference < 1500) {
      SystemNavigator.pop(animated: true);
      return true;
    } else {
      backDouble(context);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonDoubleClicked(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Column(children: [
                  Image.asset(
                    'assets/images/HIP Smart Community Icon-03.png',
                    scale: 3,
                  ),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    shrinkWrap: true,
                    children: [
                      menuButton('ผู้ใช้ทั่วไป', Icons.person, () {
                        Navigator.pushReplacementNamed(context, '/login');
                      }),
                      menuButton('พนักงาน', Icons.manage_accounts_rounded, () {
                        Navigator.pushReplacementNamed(context, '/staff');
                      })
                    ],
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget menuButton(
    title,
    icon,
    press,
  ) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.black12,
        highlightColor: Colors.transparent,
        onTap: press,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Theme.of(context).primaryColor),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
