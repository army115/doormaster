// ignore_for_file: unused_local_variable
import 'package:doormster/controller/image_controller/qrcode_controller.dart';
import 'package:doormster/screen/visitor_service/emp_opendoor_page.dart';
import 'package:doormster/widgets/scanner/scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanQRDoors extends StatefulWidget {
  const ScanQRDoors({super.key});

  @override
  State<ScanQRDoors> createState() => _ScanQRDoorsState();
}

class _ScanQRDoorsState extends State<ScanQRDoors> {
  final QRCodeController qrCodeController = Get.put(QRCodeController());
  @override
  Widget build(BuildContext context) {
    return ScannerPage(
      imageQrcode: true,
      qrOnPess: () {
        Get.to(() => Emp_Opendoor(codeNumber: qrCodeController.result.value));
      },
    );
  }
}
