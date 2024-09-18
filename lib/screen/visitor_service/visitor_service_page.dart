import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/components/list_null_opacity/logo_opacity.dart';
import 'package:doormster/screen/visitor_service/scan_idcard_page.dart';
import 'package:doormster/screen/visitor_service/visitor_idcard_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Visitor_Service extends StatefulWidget {
  Visitor_Service({Key? key});

  @override
  State<Visitor_Service> createState() => _Visitor_ServiceState();
}

class _Visitor_ServiceState extends State<Visitor_Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visitor'),
      ),
      body:
          // Logo_Opacity(title: 'no_data'.tr),
          Stack(
        alignment: Alignment.center,
        children: [
          GridView.count(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.all(30),
            primary: false,
            childAspectRatio: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25,
            crossAxisCount: 1,
            children: [
              Grid_Menu(
                  title: 'Scan IDCard',
                  press: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) => Visitor_IDCard(),
                    ));
                  },
                  icon: Icons.document_scanner_outlined),
            ],
          )
        ],
      ),
    );
  }
}
