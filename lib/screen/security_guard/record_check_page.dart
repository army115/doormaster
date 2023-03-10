import 'package:doormster/components/list_logo_opacity/logo_opacity.dart';
import 'package:flutter/material.dart';

class Record_Check extends StatefulWidget {
  const Record_Check({Key? key});

  @override
  State<Record_Check> createState() => _Record_CheckState();
}

class _Record_CheckState extends State<Record_Check> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('บันทึกเหตุการณ์ย้อนหลัง'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
        ),
        body: SafeArea(
            child: Center(
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Logo_Opacity()],
          )),
        )),
      ),
    );
  }
}
