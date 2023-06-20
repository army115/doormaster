// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  final EstampId;
  Scanner({Key? key, this.EstampId}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool open = true;

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.pauseCamera();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.05,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  'สแกน QR Code',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height * 0.05,
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white30),
              child: IconButton(
                  color: Colors.white,
                  iconSize: 30,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
            ),
          ),
          Positioned(
              right: 15,
              top: MediaQuery.of(context).size.height * 0.04,
              child: IconButton(
                onPressed: () async {
                  await controller?.toggleFlash();
                  setState(() {
                    open = !open;
                  });
                },
                icon: open
                    ? Icon(Icons.flash_off_rounded,
                        color: Colors.grey, size: 40)
                    : Icon(
                        Icons.flash_on_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
              )),
          Positioned(
            bottom: 100,
            child: (result != null)
                ? SelectableText(
                    '${result!.code}',
                    style: TextStyle(color: Colors.white),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
