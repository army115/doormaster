// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:typed_data';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'dart:convert' as convert;
import 'dart:async';
import 'dart:ui' as ui;

class Visitor_Detail extends StatefulWidget {
  var visitordData;
  var QRcodeData;
  Visitor_Detail({
    Key? key,
    required this.visitordData,
    required this.QRcodeData,
  }) : super(key: key);

  @override
  State<Visitor_Detail> createState() => _Visitor_DetailState();
}

class _Visitor_DetailState extends State<Visitor_Detail> {
  var _qrcodeImage;
  var visitorName;
  var visitorPeople;
  var startDate;
  var endDate;
  var telVisitor;
  var usableCount;

  GlobalKey _keyScreenshot = GlobalKey();

  Future _VisitorData() async {
    visitorName = widget.visitordData[0];
    visitorPeople = widget.visitordData[1];
    startDate = widget.visitordData[2];
    endDate = widget.visitordData[3];
    telVisitor = widget.visitordData[4];
    usableCount = widget.visitordData[5];
  }

  Future _QrcodeImage() async {
    var QRCode = widget.QRcodeData[2];
    setState(() {
      _qrcodeImage = convert.base64Decode(QRCode);
    });
  }

  void _saveScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _keyScreenshot.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(pngBytes),
            quality: 100,
            name: 'QRCode-${DateTime.now()}.jpg');

        print('show : ${result}');
        print('saved image successfully!!!');
        snackbar(context, Theme.of(context).primaryColor, 'บันทึกสำเร็จ',
            Icons.check);
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    _VisitorData();
    _QrcodeImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(right: 10),
      //   child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      //     Text_Button(
      //       title: 'แชร์ QRCode',
      //       press: () {
      //         ShareFilesAndScreenshotWidgets().shareScreenshot(
      //           _keyScreenshot,
      //           800,
      //           "แชร์",
      //           "QRCode-${DateTime.now()}.jpg",
      //           "image/jpg",
      //         );
      //       },
      //     )
      //   ]),
      // ),
      appBar: AppBar(
          title: Text('ลงทะเบียนผู้มาติดต่อ'),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              }),
          actions: [
            PopupMenuButton<int>(
              icon: Icon(
                Icons.share,
                size: 30,
              ),
              // offset: Offset(0, 100),
              // color: Colors.grey,
              elevation: 10,
              itemBuilder: (context) => [
                // popupmenu item 1
                PopupMenuItem(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onTap: () {
                      _saveScreenshot();
                    },
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download_rounded,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "บันทึก",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )),
                // popupmenu item 2
                PopupMenuItem(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    onTap: () {
                      ShareFilesAndScreenshotWidgets().shareScreenshot(
                        _keyScreenshot,
                        800,
                        "แชร์",
                        "QRCode-${DateTime.now()}.jpg",
                        "image/jpg",
                      );
                    },
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share_outlined,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "แชร์",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ]),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          width: double.infinity,
          // height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Card(
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          'ข้อมูลผู้มาติดต่อ',
                          style: TextStyle(fontSize: 23, color: Colors.white),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: 1.5,
                    ),
                    Text(
                      'ชื่อผู้ติดต่อ : ${visitorName}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'ติดต่อพบ : ${visitorPeople}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'เบอร์โทร : ${telVisitor}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'สิทธ์การใช้งาน : ${usableCount} ครั้ง',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'เริ่มต้น : ${startDate}',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'สิ้นสุด : ${endDate}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ]),
                ),
              ),
              RepaintBoundary(
                key: _keyScreenshot,
                child: Card(
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(children: [
                          Text(
                            'QR Code',
                            style: TextStyle(color: Colors.white, fontSize: 23),
                          )
                        ]),
                        Divider(color: Colors.white, thickness: 1.5),
                        Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.memory(
                              _qrcodeImage,
                              scale: 1.3,
                            ),
                          ),
                        ),
                        Text(
                          'รหัสผ่าน : ${widget.QRcodeData[1]}',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
