// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unused_import, use_build_context_synchronously, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:doormster/components/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/components/button/buttonback_appbar.dart';
import 'package:doormster/components/snackbar/snackbar.dart';
import 'package:doormster/components/text/text_double_colors.dart';
import 'package:doormster/controller/visitor_controller.dart';
import 'package:doormster/service/permission/permission_photos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import 'dart:convert' as convert;
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

class Visitor_Detail extends StatefulWidget {
  var visitordData;
  Visitor_Detail({
    Key? key,
    required this.visitordData,
  }) : super(key: key);

  @override
  State<Visitor_Detail> createState() => _Visitor_DetailState();
}

class _Visitor_DetailState extends State<Visitor_Detail> {
  Uint8List? _qrcodeImage;
  var visitorName;
  var meetName;
  var startDate;
  var endDate;
  var phone;

  var format = DateFormat('dd/MM/y');

  GlobalKey _keyScreenshot = GlobalKey();

  Future _VisitorData() async {
    visitorName = widget.visitordData[0];
    meetName = widget.visitordData[1];
    phone = widget.visitordData[2];
    startDate = widget.visitordData[3];
    endDate = widget.visitordData[4];
  }

  Future<void> _QrcodeImage() async {
    Uint8List bytes = convert.base64Decode(visitorController.qr_code.value);
    img.Image? image = img.decodeImage(bytes);
    img.Image croppedImage =
        img.copyCrop(image!, x: 60, y: 117, height: 160, width: 160);
    _qrcodeImage =
        Uint8List.fromList(img.encodeJpg(croppedImage, quality: 100));
    setState(() {});
  }

  Future<void> _saveScreenshot() async {
    try {
      final result = await ImageGallerySaver.saveImage(_qrcodeImage!,
          quality: 100, name: 'QRCode-${DateTime.now()}.jpg');

      if (result["isSuccess"] == true) {
        print('saved image successfully!!!');
        snackbar(Theme.of(context).primaryColor, 'capture_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        print('saved image successfully!!!');
        snackbar(Colors.red, 'capture_fail'.tr, Icons.highlight_off_rounded);
      }
      // }
    } catch (error) {
      print(error);
      dialogOnebutton_Subtitle(
          title: 'occur_error'.tr,
          subtitle: 'capture_fail_again'.tr,
          icon: Icons.warning_amber_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () {
            Get.back();
          },
          click: false,
          backBtn: false,
          willpop: false);
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
              // Get.until((route) => route.isFirst);
              Get.back();
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
                      onTap: () async {
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
                        ShareFilesAndScreenshotWidgets().shareFile(
                            "share".tr,
                            "QRCode-${DateTime.now()}.jpg",
                            _qrcodeImage!,
                            "image/jpg");
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
            child: RefreshIndicator(
          onRefresh: () async {
            _QrcodeImage();
          },
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.white,
                          thickness: 1.5,
                        ),
                        Text('${'visitor'.tr} : $visitorName',
                            style: TextStyle(color: Colors.white)),
                        Text('${'meet_name'.tr} : $meetName',
                            style: TextStyle(color: Colors.white)),
                        Text('${'phone_number'.tr} : $phone',
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            ]),
                            Divider(color: Colors.white, thickness: 1.5),
                            Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Image.memory(
                                  fit: BoxFit.cover,
                                  height: 300,
                                  _qrcodeImage!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
