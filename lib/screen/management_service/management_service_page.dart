import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Management_Service extends StatefulWidget {
  Management_Service({Key? key});

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
      body: Logo_Opacity(title: 'no_data'.tr),
    );
  }
}
