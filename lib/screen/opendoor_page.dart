import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Opendoor_Page extends StatefulWidget {
  Opendoor_Page({Key? key}) : super(key: key);

  @override
  State<Opendoor_Page> createState() => _Opendoor_PageState();
}

class _Opendoor_PageState extends State<Opendoor_Page> {
  // final GlobalKey _key = GlobalKey();
  // QRViewController? controller;
  // Barcode? result;

  // void qr(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((event) {
  //     setState(() {
  //       result = event;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Expanded(
          //   flex: 5,
          //   // height: MediaQuery.of(context).size.height * 0.5,
          //   // width: MediaQuery.of(context).size.width * 0.8,
          //   child: QRView(
          //       key: _key,
          //       onQRViewCreated: qr,
          //       overlay: QrScannerOverlayShape(
          //           borderColor: Colors.white,
          //           borderRadius: 10,
          //           borderLength: 30,
          //           borderWidth: 10,
          //           cutOutSize: 250)),
          // ),
          // // SizedBox(
          // //   height: 10,
          // // ),
          // Expanded(
          //   flex: 1,
          //   child: Center(
          //     child: (result != null)
          //         ? Text('${result!.code}')
          //         : Text('Scan QR Code'),
          //   ),
          // )
        ],
      ),
    );
  }
}
