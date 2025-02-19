// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, unused_import, use_build_context_synchronously, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:developer';
import 'dart:io';
import 'package:doormster/controller/image_controller/qrcode_controller.dart';
import 'package:doormster/style/textStyle.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_twobutton.dart';
import 'package:doormster/widgets/alertDialog/dialog_qrcode.dart';
import 'package:doormster/widgets/button/buttonback_appbar.dart';
import 'package:doormster/widgets/image/qr_code_image.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:doormster/widgets/text/text_double_colors.dart';
import 'package:doormster/controller/visitor_controller/visitor_controller.dart';
import 'package:doormster/service/permission/permission_photos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert' as convert;
import 'dart:ui' as ui;
import 'package:share_plus/share_plus.dart';

class Visitor_Detail extends StatefulWidget {
  var visitordData;
  String qr_code;
  Visitor_Detail({
    super.key,
    required this.visitordData,
    required this.qr_code,
  });

  @override
  State<Visitor_Detail> createState() => _Visitor_DetailState();
}

class _Visitor_DetailState extends State<Visitor_Detail> {
  final QRCodeController qrCodeController = Get.put(QRCodeController());
  var visitorName;
  var meetName;
  var startDate;
  var endDate;
  var phone;
  var house;

  var format = DateFormat('dd/MM/y');

  Future _VisitorData() async {
    visitorName = widget.visitordData[0];
    meetName = widget.visitordData[1];
    phone = widget.visitordData[2];
    house = widget.visitordData[3];
    startDate = widget.visitordData[4];
    endDate = widget.visitordData[5];
  }

  @override
  void initState() {
    super.initState();
    _VisitorData();
    qrCodeController.generateQrImage(
        name: 'HIP Smart Community',
        data: widget.qr_code,
        endDate: endDate,
        startDate: startDate);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Get.until((route) => route.isFirst);
          return true;
        },
        child:
            // Obx(() {
            // qrCodeController.processQRCode(widget.qr_code);
            // qrCodeController.generateQrImage(
            //     data: widget.qr_code,
            //     name: 'HIP Smart Community',
            //     startDate: startDate,
            //     endDate: endDate);
            // return
            Scaffold(
                appBar: AppBar(
                    title: Text('visitor'.tr),
                    // leading: button_back(() {
                    //   Get.until((route) => route.isFirst);
                    // }),
                    actions: [
                      PopupMenuButton(
                        icon: Icon(
                          Icons.share,
                          size: 30,
                        ),
                        elevation: 10,
                        position: PopupMenuPosition.under,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        itemBuilder: (context) => [
                          popupMenu(
                              ontap: () async {
                                permissionAddPhotos(context,
                                    () => qrCodeController.saveQRCodeImage());
                              },
                              title: "save".tr,
                              icon: Icons.download_rounded),
                          popupMenu(
                            ontap: () async {
                              qrCodeController.shareQRCodeImage();
                            },
                            title: "share".tr,
                            icon: Icons.share_outlined,
                          )
                        ],
                      ),
                    ]),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      width: double.infinity,
                      child: Column(
                        children: [
                          QrCodeImage(
                            qr_code: widget.qr_code,
                          ),
                          // Card(
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(15),
                          //   ),
                          //   elevation: 8,
                          //   shadowColor: Colors.black45,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(10),
                          //     child: Image.memory(
                          //       qrCodeController.qrCodeImage.value!,
                          //       width: 250,
                          //       height: 250,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(height: 10),
                          buildInfo(),
                        ],
                      ),
                    ),
                  ),
                ))
        // ;})
        );
  }

  Widget showQRcode() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      shadowColor: Colors.black45,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: QrImageView(
            data: widget.qr_code,
            backgroundColor: Colors.white,
            version: QrVersions.auto,
            embeddedImageEmitsError: true,
            constrainErrorBounds: true,
            gapless: true,
            embeddedImageStyle: QrEmbeddedImageStyle(size: Size(60, 60)),
            embeddedImage: AssetImage(
              "assets/images/HIP_Smart_Community_Logo_Icon.png",
            ),
            size: 250,
            dataModuleStyle: QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          )),
    );
  }

  Widget buildInfo() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      shadowColor: Colors.black38,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'visitor_info'.tr,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            UserInfoRow(label: 'visitor_name'.tr, value: visitorName),
            UserInfoRow(label: 'meet_name'.tr, value: meetName),
            UserInfoRow(label: 'phone_number'.tr, value: phone),
            UserInfoRow(label: 'house_number'.tr, value: house),
            UserInfoRow(
                label: 'start_date'.tr,
                value: format.format(DateTime.parse('$startDate'))),
            UserInfoRow(
                label: 'end_date'.tr,
                value: format.format(DateTime.parse('$endDate'))),
          ],
        ),
      ),
    );
  }

  PopupMenuItem popupMenu(
      {required ontap, required String title, required IconData icon}) {
    return PopupMenuItem(
        padding: EdgeInsets.symmetric(horizontal: 10),
        onTap: ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 25,
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ));
  }

  Widget UserInfoRow({
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label :",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Get.theme.dividerColor),
            ),
            Expanded(
              child: Text(
                textAlign: TextAlign.end,
                value,
              ),
            ),
          ],
        ),
        const Divider(height: 20),
      ],
    );
  }
}
