import 'package:doormster/controller/image_controller/qrcode_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scan/scan.dart';

// ignore: non_constant_identifier_names
class ScannerPage extends StatelessWidget {
  final bool imageQrcode;
  final VoidCallback qrOnPess;
  ScannerPage({super.key, required this.imageQrcode, required this.qrOnPess});
  final QRCodeController qrController = Get.put(QRCodeController());
  ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     // Get.until((route) => route.isFirst);
        //     return true;
        //   },
        //   child:
        Obx(() {
      return Stack(
        alignment: Alignment.center,
        children: [
          ScanView(
            controller: controller,
            scanAreaScale: .7,
            scanLineColor: Colors.green,
            onCapture: (data) {
              qrOnPess();
              qrController.result.value = data;
            },
          ),
          Positioned(
              top: Get.mediaQuery.size.height * 0.05,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text('${'scan'.tr} QR Code',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )))),
          Positioned(
            left: 10,
            top: Get.mediaQuery.size.height * 0.05,
            child: Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white30),
              child: IconButton(
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
          ),
          Positioned(
              right: 15,
              bottom: Get.mediaQuery.size.height * 0.04,
              child: Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white30),
                child: IconButton(
                  onPressed: () async {
                    controller.toggleTorchMode();
                    qrController.openflash.value =
                        !qrController.openflash.value;
                  },
                  icon: qrController.openflash.value
                      ? const Icon(Icons.flash_off_rounded,
                          color: Colors.white, size: 30)
                      : const Icon(
                          Icons.flash_on_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                ),
              )),
          imageQrcode
              ? Positioned(
                  left: 10,
                  bottom: Get.mediaQuery.size.height * 0.04,
                  child: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white30),
                    child: IconButton(
                      onPressed: () {
                        qrController.pickQRCodeImage(qrOnPess);
                      },
                      icon: const Icon(Icons.image,
                          color: Colors.white, size: 30),
                    ),
                  ))
              : Container(),
          // Positioned(
          //   bottom: 100,
          //   child: (qrController.result != '')
          //       ? SelectableText(
          //           '${qrController.result}',
          //           style: const TextStyle(color: Colors.white),
          //         )
          //       : Container(),
          // ),
        ],
      );
    }
            // ),
            );
  }
}
