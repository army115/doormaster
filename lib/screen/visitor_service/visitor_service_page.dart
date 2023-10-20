import 'package:doormster/components/girdManu/grid_menu.dart';
import 'package:doormster/screen/visitor_service/scan_idcard_page.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text('Visitor'),
      ),
      body: Stack(
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
                      builder: (context) => Scan_IDCard(),
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
