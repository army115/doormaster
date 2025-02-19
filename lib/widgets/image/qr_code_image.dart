// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeImage extends StatelessWidget {
  final String qr_code;
  final String? image;
  const QrCodeImage({super.key, required this.qr_code, this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 8,
      shadowColor: Colors.black45,
      child: Padding(
          padding: const EdgeInsets.all(10),
          child: QrImageView(
            data: qr_code,
            backgroundColor: Colors.white,
            version: QrVersions.auto,
            embeddedImageEmitsError: true,
            constrainErrorBounds: true,
            gapless: true,
            embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(60, 60)),
            embeddedImage: AssetImage(
              image ?? "assets/images/HIP_Smart_Community_Logo_Icon.png",
            ),
            size: 250,
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
          )),
    );
  }
}
