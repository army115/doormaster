import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Visitor_Service extends StatefulWidget {
  const Visitor_Service({Key? key});
  static const String route = '/visitor';

  @override
  State<Visitor_Service> createState() => _Visitor_ServiceState();
}

class _Visitor_ServiceState extends State<Visitor_Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Visitor'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Center(child: Text('Visitor')),
    );
  }
}
