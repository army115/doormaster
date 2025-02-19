import 'package:doormster/controller/image_controller/qrcode_controller.dart';
import 'package:doormster/screen/estamp_service/estamp_detail.dart';
import 'package:doormster/widgets/scanner/scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Scan_Estamp extends StatefulWidget {
  const Scan_Estamp({super.key});

  @override
  State<Scan_Estamp> createState() => _Scan_EstampState();
}

class _Scan_EstampState extends State<Scan_Estamp> {
  final QRCodeController qrCodeController = Get.put(QRCodeController());
  @override
  Widget build(BuildContext context) {
    return ScannerPage(
      imageQrcode: true,
      qrOnPess: () {
        Get.to(() => Estamp_Detail(prakingId: qrCodeController.result.value));
      },
    );
  }
}
