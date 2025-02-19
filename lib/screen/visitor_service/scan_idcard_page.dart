// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, deprecated_member_use, avoid_print

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:doormster/widgets/loading/loading.dart';
import 'package:doormster/controller/visitor_controller/scan_idcard_controller.dart';
import 'package:doormster/style/overlay_frame.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

class Scan_IDCard extends StatefulWidget {
  const Scan_IDCard({super.key});

  @override
  State<Scan_IDCard> createState() => _Scan_IDCardState();
}

class _Scan_IDCardState extends State<Scan_IDCard> {
  final ScanIDCardController scanIDCardController =
      Get.put(ScanIDCardController());
  CameraController? controller;
  List<CameraDescription> camera = [];
  XFile? image;

  Future<void> _initializeCamera() async {
    try {
      camera = await availableCameras();
      if (camera.isEmpty) {
        debugPrint("No cameras found.");
        return;
      }
      controller = CameraController(
        camera[0],
        ResolutionPreset.high,
      );
      await controller!.initialize();
      setState(() {});
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(
              controller!,
              child: Container(
                decoration: ShapeDecoration(
                  shape: OverlayShape(
                    borderWidth: 10,
                    borderRadius: 10,
                    cutOutHeight: 240,
                    cutOutWidth: 370,
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.mediaQuery.size.height * 0.06,
              child: const Text(
                'สแกนบัตรประชาชน',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white30,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    iconSize: 50,
                    onPressed: () => scanIDCardController.capture(controller!),
                    icon: const Icon(
                      Icons.camera,
                    ),
                  ),
                ),
              ),
            ),
            scanIDCardController.loading.isTrue ? Loading() : Container(),
          ],
        ),
      ),
    );
  }
}

// Widget showImageScanner() {
//   final ScanIDCardController scanIDCardController =
//       Get.put(ScanIDCardController());
//   return Obx(
//     () => Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             decoration: ShapeDecoration(
//               image: DecorationImage(
//                   image:
//                       FileImage(File(scanIDCardController.image.value.path))),
//               shape: OverlayShape(
//                 borderWidth: 10,
//                 borderRadius: 10,
//                 cutOutHeight: 240,
//                 cutOutWidth: 370,
//               ),
//             ),
//           ),
//           Positioned(
//             left: 10,
//             top: Get.mediaQuery.size.height * 0.05,
//             child: Container(
//               decoration: const BoxDecoration(
//                   shape: BoxShape.circle, color: Colors.white30),
//               child: IconButton(
//                   color: Colors.white,
//                   iconSize: 30,
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: const Icon(Icons.arrow_back_ios_new_rounded)),
//             ),
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 10),
//               child: Container(
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.white30,
//                 ),
//                 child: IconButton(
//                   color: Colors.white,
//                   iconSize: 50,
//                   onPressed: () => scanIDCardController.sendID(),
//                   icon: const Icon(
//                     Icons.send,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           scanIDCardController.loading.isTrue ? Loading() : Container(),
//         ],
//       ),
//     ),
//   );
// }
