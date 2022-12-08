import 'package:doormster/components/button/text_button.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Contact_Detail extends StatefulWidget {
  String name;
  String codeId;
  String phone;
  String location;
  String date;
  List<String> texts;
  Contact_Detail(
      {Key? key,
      required this.name,
      required this.codeId,
      required this.phone,
      required this.location,
      required this.date,
      required this.texts})
      : super(key: key);

  @override
  State<Contact_Detail> createState() => _Contact_DetailState();
}

class _Contact_DetailState extends State<Contact_Detail> {
  late TextEditingController _controller;
  late List<String> texts;
  late String result;
  Future Texts() async {
    texts = [
      widget.name,
      widget.codeId,
      widget.phone,
      widget.location,
      widget.date
    ];
    result = widget.texts.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    Texts();
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text_Button(
            title: 'ส่งลิงค์',
            press: () {},
          )
        ]),
      ),
      appBar: AppBar(title: Text('ลงทะเบียนล่วงหน้าผู้มาติดต่อ')),
      body: SafeArea(
        // child: Center(
        child: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(children: [
            Card(
              color: Colors.indigo,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   '${widget.name}',
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   '${widget.codeId}',
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   '${widget.phone}',
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   '${widget.location}',
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      // Text(
                      //   '${widget.date}',
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      Text('$result', style: TextStyle(color: Colors.white))
                    ]),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            QrImage(
              data: result,
              size: 200,
              // embeddedImageStyle: QrEmbeddedImageStyle(
              //   size: Size(80, 80)
              //   ),
            ),
          ]),
        )),
        // )
      ),
    );
  }
}
