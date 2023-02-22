import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Auth_Page extends StatefulWidget {
  const Auth_Page({Key? key});

  @override
  State<Auth_Page> createState() => _Auth_PageState();
}

class _Auth_PageState extends State<Auth_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
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
                  menuButton('ลูกบ้าน', Icons.person, () {
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
