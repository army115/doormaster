import 'dart:async';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Parcel_service extends StatefulWidget {
  Parcel_service({Key? key});

  @override
  State<Parcel_service> createState() => _Parcel_serviceState();
}

class _Parcel_serviceState extends State<Parcel_service> {
  String text = "";
  final StreamController<String> controller = StreamController<String>();
  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Parcels'),
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
