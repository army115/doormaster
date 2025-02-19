import 'package:doormster/screen/qr_smart_access/confirm_visitor_page.dart';
import 'package:doormster/service/connected/check_connected.dart';
import 'package:doormster/widgets/scanner/scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScanQrVisitor extends StatefulWidget {
  const ScanQrVisitor({super.key});

  @override
  State<ScanQrVisitor> createState() => _ScanQrVisitorState();
}

class _ScanQrVisitorState extends State<ScanQrVisitor> {
  @override
  Widget build(BuildContext context) {
    return ScannerPage(
        imageQrcode: true,
        qrOnPess: () {
          Get.to(() => const ConfirmVisitor());
        });
  }
}
