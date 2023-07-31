// ignore_for_file: avoid_unnecessary_containers, must_be_immutable, unused_import
import 'dart:developer';

import 'package:doormster/components/bottombar/bottombar.dart';
import 'package:doormster/components/drawer/drawer.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class Visitor_Service extends StatefulWidget {
  Visitor_Service({Key? key});
  static const String route = '/visitor';

  @override
  State<Visitor_Service> createState() => _Visitor_ServiceState();
}

class _Visitor_ServiceState extends State<Visitor_Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Visitor'),
        // leading: IconButton(
        //     icon: Icon(Icons.menu),
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     }),
      ),
      body: Logo_Opacity(title: 'ไม่มีข้อมูล'),
    );
  }
}
