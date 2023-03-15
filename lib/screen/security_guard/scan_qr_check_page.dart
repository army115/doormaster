import 'dart:io';
import 'package:doormster/components/alertDialog/alert_dialog_twobutton_subtext.dart';
import 'package:doormster/components/loading/loading.dart';
import 'package:doormster/screen/security_guard/add_checkpoint_page.dart';
import 'package:doormster/screen/security_guard/check_point_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQR_Check extends StatefulWidget {
  final name;
  ScanQR_Check({
    Key? key,
    this.name,
  }) : super(key: key);

  @override
  State<ScanQR_Check> createState() => _ScanQR_CheckState();
}

class _ScanQR_CheckState extends State<ScanQR_Check> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool open = true;
  bool loading = false;
  Position? position;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.pauseCamera();
      });
      if (widget.name == 'check') {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Check_Point(
                timeCheck: DateTime.now(),
                checkpointId: '${result?.code}',
                lat: position?.latitude,
                lng: position?.longitude),
          ),
        );
      } else if (widget.name == 'add') {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => Add_CheckPoint(
                timeCheck: DateTime.now(),
                checkpointId: '${result?.code}',
                lat: position?.latitude,
                lng: position?.longitude),
          ),
        );
      }
    });
  }

  Future getLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (error) {
      print(error);
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        return false;
      },
      child: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Stack(
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
                      top: 20,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text(
                          'สแกน QR Code',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )),
                  Positioned(
                    left: 10,
                    top: 20,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white30),
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
                      top: 15,
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
                ],
              ),
            ),
          ),
          loading ? Loading() : Container()
        ],
      ),
    );
  }
}
