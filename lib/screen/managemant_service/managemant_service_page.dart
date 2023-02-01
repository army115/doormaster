import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Managemant_Service extends StatefulWidget {
  const Managemant_Service({Key? key});

  @override
  State<Managemant_Service> createState() => _Managemant_ServiceState();
}

class _Managemant_ServiceState extends State<Managemant_Service> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Managemant'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Center(child: Text('Managemant')),
    );
  }
}
