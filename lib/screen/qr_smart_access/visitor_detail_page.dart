// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unused_import, use_build_context_synchronously, avoid_print

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/service/permission/permission_photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'dart:convert' as convert;
import 'dart:ui' as ui;
// import 'dart:async';

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

  var format = DateFormat('dd/MM/y HH:mm:ss');

  GlobalKey _keyScreenshot = GlobalKey();

  Future _VisitorData() async {
    visitorName = widget.visitordData[0];
    visitorPeople = widget.visitordData[1];
    startDate = widget.visitordData[2];
    endDate = widget.visitordData[3];
    telVisitor = widget.visitordData[4];
    usableCount = widget.visitordData[5];
  }

  Future<void> _QrcodeImage() async {
    if (widget.QRcodeData == null) {
      var QRCode = widget.visitordData[6];
      setState(() {
        _qrcodeImage = convert.base64Decode(QRCode);
      });
    } else {
      var QRCode = widget.QRcodeData[2];
      setState(() {
        _qrcodeImage = convert.base64Decode(QRCode);
      });
    }
  }

  Future<void> _saveScreenshot() async {
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

        if (result["isSuccess"] == true) {
          print('saved image successfully!!!');
          snackbar(Theme.of(context).primaryColor, 'capture_success'.tr,
              Icons.check_circle_outline_rounded);
        } else {
          print('saved image successfully!!!');
          snackbar(Colors.red, 'capture_fail'.tr, Icons.highlight_off_rounded);
        }
      }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle('found_error'.tr, 'capture_fail_again'.tr,
          Icons.warning_amber_rounded, Colors.orange, 'ok'.tr, () {
        Navigator.of(context).pop();
      }, false, false);
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
    return WillPopScope(
      onWillPop: () async {
        Get.until((route) => route.isFirst);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text('visitor'.tr),
            leading: button_back(() {
              Get.until((route) => route.isFirst);
            }),
            actions: [
              PopupMenuButton(
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
                        permissionAddPhotos(context, () => _saveScreenshot());
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
                            "save".tr,
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
                          "share".tr,
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
                            "share".tr,
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            width: double.infinity,
            // height: Get.mediaQuery.size.height,
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(children: [
                      Row(
                        children: [
                          Text(
                            'visitor_info'.tr,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1.5,
                      ),
                      Text('${'visitor'.tr} : ${visitorName}',
                          style: TextStyle(color: Colors.white)),
                      Text('${'contacts'.tr} : ${visitorPeople}',
                          style: TextStyle(color: Colors.white)),
                      Text('${'phone_number'.tr} : ${telVisitor}',
                          style: TextStyle(color: Colors.white)),
                      widget.QRcodeData == null
                          ? Container()
                          : Text('${'access_count'.tr} : ${usableCount}',
                              style: TextStyle(color: Colors.white)),
                      Text(
                          '${'start'.tr} : ${format.format(DateTime.parse('$startDate'))}',
                          style: TextStyle(color: Colors.white)),
                      Text(
                          '${'end'.tr} : ${format.format(DateTime.parse('$endDate'))}',
                          style: TextStyle(color: Colors.white)),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RepaintBoundary(
                  key: _keyScreenshot,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(children: [
                            Text(
                              'QR Code',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
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
                          SizedBox(
                            height: 10,
                          ),
                          widget.QRcodeData == null
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'password'.tr,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    SelectableText(
                                      ' : ${widget.QRcodeData[1]}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                  ],
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
      ),
    );
  }
}
