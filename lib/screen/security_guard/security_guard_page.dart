import 'package:doormster/components/drawer/drawer.dart';
import 'package:flutter/material.dart';

class Security_Guard extends StatefulWidget {
  const Security_Guard({Key? key});

  @override
  State<Security_Guard> createState() => _Security_GuardState();
}

class _Security_GuardState extends State<Security_Guard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Security Guard'),
        leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
      ),
      body: Center(child: Text('Security_Guard')),
    );
  }
}
