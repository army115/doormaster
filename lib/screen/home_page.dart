import 'package:doormster/components/girdManu/gird_menu.dart';
import 'package:doormster/screen/contact_page.dart';
import 'package:doormster/screen/opendoor_page.dart';
import 'package:flutter/material.dart';

class Home_Page extends StatefulWidget {
  Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('หน้าแรก')),
      body: SafeArea(
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Contact_Page()));
                  },
                ),
                Gird_Menu(
                  title: 'เปิดประตู',
                  icon: Icons.person,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Opendoor_Page()));
                  },
                ),
                Gird_Menu(
                  title: 'Call Guard',
                  icon: Icons.person,
                  press: () {},
                ),
                Gird_Menu(
                  title: 'Call Reception/นิติบุคคล',
                  icon: Icons.person,
                  press: () {},
                ),
              ],
            )
          ]),
        ),
      )),
    );
  }
}
