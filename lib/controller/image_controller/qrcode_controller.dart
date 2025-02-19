import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/widgets/snackbar/snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scan/scan.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class QRCodeController extends GetxController {
  Rx<Uint8List?> qrCodeImage = Rx<Uint8List?>(null);
  Rx<Uint8List?> qrCodeCropImage = Rx<Uint8List?>(null);
  RxString result = ''.obs;
  RxBool openflash = true.obs;

  Future<void> pickQRCodeImage(qrOnPess) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        String? qrCodeData = await Scan.parse(pickedFile.path);
        if (qrCodeData != null) {
          result.value = qrCodeData;
          qrOnPess();
          if (kDebugMode) {
            debugPrint(qrCodeData);
          }
        } else {
          snackbar(Colors.red, 'qrcode_not_found'.tr, Icons.close);
        }
      } else {
        if (kDebugMode) {
          debugPrint("No image selected.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('error : $e');
      }
      dialogOnebutton_Subtitle(
          title: 'occur_error'.tr,
          subtitle: 'process_error'.tr,
          icon: Icons.warning_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () {
            Get.back();
          },
          backBtn: false,
          click: true,
          willpop: true);
    }
  }

  Future<void> processQRCode(String base64Data) async {
    try {
      Uint8List bytes = convert.base64Decode(base64Data);
      qrCodeImage.value = bytes;
      img.Image? image = img.decodeImage(bytes);
      if (image != null) {
        img.Image croppedImage =
            img.copyCrop(image, x: 76, y: 145, height: 130, width: 130);
        qrCodeCropImage.value =
            Uint8List.fromList(img.encodeJpg(croppedImage, quality: 100));
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error processing QR code: $e");
      }
    }
  }

  Future<Uint8List> generateQrImage({
    required String name,
    required String data,
    required String startDate,
    required String endDate,
  }) async {
    final byteDataImage = await rootBundle
        .load('assets/images/HIP_Smart_Community_Logo_Icon.png');
    final bufferImage = byteDataImage.buffer.asUint8List();
    final image = await decodeImageFromList(bufferImage);

    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      embeddedImage: image,
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Colors.black,
      ),
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size(200, 200),
      ),
      color: Colors.black,
      gapless: true,
    );
    final qrImage = await qrPainter.toImageData(800);
    final qrUint8List = qrImage!.buffer.asUint8List();
    final qrUiImage = await decodeImageFromList(qrUint8List);

    // Create a white background canvas
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..color = Colors.white;

    const imageWidth = 1000;
    const imageHeight = 1200;

    // Draw white background
    canvas.drawRect(
        const Rect.fromLTWH(0, 0, imageWidth + .0, imageHeight + .0), paint);

    // Draw the QR code in the center
    final qrOffset = Offset((imageWidth - qrUiImage.width) / 2, 180);
    canvas.drawImage(qrUiImage, qrOffset, paint);

    // Add text (name) at the top
    const textStyle =
        TextStyle(color: Colors.black, fontSize: 55, fontFamily: 'Prompt');
    final textSpan = TextSpan(text: name, style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
        (imageWidth - textPainter.width) / 2, 50); // 50 is the top margin
    textPainter.paint(canvas, textOffset);

    // Add text (start date) at the bottom
    final startDateTextSpan =
        TextSpan(text: 'วันเริ่มต้น: $startDate', style: textStyle);
    final startDateTextPainter = TextPainter(
      text: startDateTextSpan,
      textDirection: ui.TextDirection.ltr,
    );
    startDateTextPainter.layout();
    final startDateTextOffset = Offset(
        (imageWidth - startDateTextPainter.width) / 2,
        imageHeight - 180); // 180 is the bottom margin
    startDateTextPainter.paint(canvas, startDateTextOffset);

    // Add text (end date) at the bottom
    final endDateTextSpan =
        TextSpan(text: 'วันหมดอายุ: $endDate', style: textStyle);
    final endDateTextPainter = TextPainter(
      text: endDateTextSpan,
      textDirection: ui.TextDirection.ltr,
    );
    endDateTextPainter.layout();
    final endDateTextOffset = Offset(
        (imageWidth - endDateTextPainter.width) / 2,
        imageHeight - 120); // 120 is the bottom margin
    endDateTextPainter.paint(canvas, endDateTextOffset);

    // Convert canvas to image
    final picture = recorder.endRecording();
    final finalImage = await picture.toImage(imageWidth, imageHeight);
    final byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);

    qrCodeImage.value = byteData!.buffer.asUint8List();
    return byteData.buffer.asUint8List();
  }

  Future<void> shareQRCodeImage() async {
    try {
      if (qrCodeImage.value == null) {
        dialogOnebutton_Subtitle(
            title: 'occur_error'.tr,
            subtitle: 'share_error'.tr,
            icon: Icons.warning_rounded,
            colorIcon: Colors.orange,
            textButton: 'ok'.tr,
            press: () => Get.back(),
            backBtn: true,
            click: true,
            willpop: true);
        return;
      }
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/QRCode-${DateTime.now()}.jpg');
      await file.writeAsBytes(qrCodeImage.value!);
      final shareStatus = await Share.shareXFiles([XFile(file.path)],
          text: "Share your QR Code");
      if (shareStatus.status == ShareResultStatus.success) {
        snackbar(
          Colors.green,
          'share_success'.tr,
          Icons.check_circle_outline_rounded,
        );
      } else if (shareStatus.status == ShareResultStatus.dismissed) {
      } else {
        snackbar(
          Colors.red,
          'share_fail'.tr,
          Icons.highlight_off_rounded,
        );
      }
      if (kDebugMode) {
        debugPrint('share: ${shareStatus.status.name}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Error sharing QR code: $e");
      }
      dialogOnebutton_Subtitle(
          title: 'occur_error'.tr,
          subtitle: 'share_error'.tr,
          icon: Icons.warning_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () => Get.back(),
          backBtn: true,
          click: true,
          willpop: true);
    }
  }

  Future<void> saveQRCodeImage() async {
    try {
      final result = await ImageGallerySaver.saveImage(qrCodeImage.value!,
          quality: 100, name: 'QRCode-${DateTime.now()}.jpg');

      if (result["isSuccess"] == true) {
        if (kDebugMode) {
          debugPrint('saved image successfully!!!');
        }
        snackbar(Colors.green, 'capture_success'.tr,
            Icons.check_circle_outline_rounded);
      } else {
        if (kDebugMode) {
          debugPrint('saved image successfully!!!');
        }
        snackbar(Colors.red, 'capture_fail'.tr, Icons.highlight_off_rounded);
      }
    } catch (error) {
      dialogOnebutton_Subtitle(
          title: 'occur_error'.tr,
          subtitle: 'capture_fail_again'.tr,
          icon: Icons.warning_amber_rounded,
          colorIcon: Colors.orange,
          textButton: 'ok'.tr,
          press: () {
            Get.back();
          },
          click: false,
          backBtn: false,
          willpop: false);
    }
  }
}
