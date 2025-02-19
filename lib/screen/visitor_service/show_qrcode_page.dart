// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:typed_data';
import 'package:doormster/controller/image_controller/qrcode_controller.dart';
import 'package:doormster/widgets/button/buttonback_appbar.dart';
import 'package:doormster/widgets/image/qr_code_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:imin_printer/enums.dart';
import 'package:imin_printer/imin_printer.dart';
import 'package:imin_printer/imin_style.dart';

class Show_QRcode extends StatefulWidget {
  var visitordData;
  String qr_code;
  // String code_number;
  Show_QRcode({
    super.key,
    required this.visitordData,
    required this.qr_code,
    // required this.code_number,
  });

  @override
  State<Show_QRcode> createState() => _Show_QRcodeState();
}

class _Show_QRcodeState extends State<Show_QRcode> {
  final QRCodeController qrCodeController = Get.put(QRCodeController());
  var visitorName;
  var meetName;
  var phone;
  var house;
  var plateNum;
  var details;
  var startDate;
  var endDate;
  final iminPrinter = IminPrinter();
  String version = '1.0.0';

  Future _VisitorData() async {
    visitorName = widget.visitordData[0];
    meetName = widget.visitordData[1];
    phone = widget.visitordData[2];
    house = widget.visitordData[3];
    plateNum = widget.visitordData[4];
    details = widget.visitordData[5];
    startDate = widget.visitordData[6];
    endDate = widget.visitordData[7];
  }

  Future printSlip(unit8) async {
    await iminPrinter.printSingleBitmap(qrCodeController.qrCodeImage.value!,
        pictureStyle: IminPictureStyle(
          width: 1000,
          height: 1000,
          alignment: IminPrintAlign.center,
        ));
    iminPrinter.printAndFeedPaper(50);
  }

  @override
  void initState() {
    super.initState();
    _VisitorData();
    qrCodeController.generateQrImage(
        data: widget.qr_code,
        name: 'HIP Smart Community',
        startDate: startDate,
        endDate: endDate);
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

            // return
            Scaffold(
          appBar: AppBar(
            title: const Text("QR Code & Details"),
            // leading: button_back(() {
            //   Get.until((route) => route.isFirst);
            // }),
            actions: [
              IconButton(
                  onPressed: () {
                    printSlip(qrCodeController.qrCodeImage.value);
                  },
                  icon: const Icon(Icons.print)),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 80),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    QrCodeImage(qr_code: widget.qr_code),
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
                    Card(
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
                            UserInfoRow(
                                label: 'visitor_name'.tr, value: visitorName),
                            UserInfoRow(label: 'meet_name'.tr, value: meetName),
                            UserInfoRow(label: 'phone_number'.tr, value: phone),
                            UserInfoRow(label: 'house_number'.tr, value: house),
                            UserInfoRow(
                                label: 'license_plate'.tr, value: plateNum),
                            UserInfoRow(label: 'purpose'.tr, value: details),
                            UserInfoRow(
                              label: 'start_date'.tr,
                              value: startDate,
                            ),
                            UserInfoRow(
                              label: 'end_date'.tr,
                              value: endDate,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        // ;}),
        );
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
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).dividerColor),
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
