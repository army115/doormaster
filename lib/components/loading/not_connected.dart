import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Not_Connected extends StatelessWidget {
  const Not_Connected({Key? key});

  Future<bool> exit() async {
    SystemNavigator.pop(animated: true);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: MaterialApp(
          title: 'HIP Smart Community',
          debugShowCheckedModeBanner: false,
          home: Container(
              color: Theme.of(context).primaryColor,
              child: Column(children: [])),
        ),
        onWillPop: () => exit());
  }
}
