import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Management_Service extends StatefulWidget {
  Management_Service({Key? key});
  static const String route = '/managemant';

  @override
  State<Management_Service> createState() => _Management_ServiceState();
}

class _Management_ServiceState extends State<Management_Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Management'),
        // leading: IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     }),
      ),
      body: Center(child: Text('Management')),
    );
  }
}