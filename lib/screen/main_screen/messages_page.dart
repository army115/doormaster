import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Messages_Page extends StatefulWidget {
  const Messages_Page({Key? key});

  @override
  State<Messages_Page> createState() => _Messages_PageState();
}

class _Messages_PageState extends State<Messages_Page> {
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
