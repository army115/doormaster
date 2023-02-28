import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Parcel_service extends StatefulWidget {
  Parcel_service({Key? key});
  static const String route = '/parcel';

  @override
  State<Parcel_service> createState() => _Parcel_serviceState();
}

class _Parcel_serviceState extends State<Parcel_service> {
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
      body: Center(child: Text('Parcels')),
    );
  }
}
