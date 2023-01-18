import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Massages_Page extends StatefulWidget {
  const Massages_Page({Key? key});

  @override
  State<Massages_Page> createState() => _Massages_PageState();
}

class _Massages_PageState extends State<Massages_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Massages'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Center(child: Text('Massages')),
    );
  }
}
