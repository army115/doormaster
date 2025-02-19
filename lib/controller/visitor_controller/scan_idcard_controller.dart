import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:doormster/service/connected/error_status_code.dart';
import 'package:doormster/widgets/actions/disconnected_dialog.dart';
import 'package:doormster/widgets/alertDialog/alert_dialog_onebutton_subtext.dart';
import 'package:doormster/models/id_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'dart:convert' as convert;

// final ScanIDCardController scanIDCardController =
//     Get.put(ScanIDCardController());

class ScanIDCardController extends GetxController {
  Rx<XFile> image = XFile("").obs;
  RxBool loading = false.obs;
  // RxString idCard = ''.obs;
  // RxString titleName = ''.obs;
  // RxString name = ''.obs;
  final idCard = TextEditingController();
  final titleName = TextEditingController();
  final name = TextEditingController();
  Rx<Uint8List?> imageIDCard = Rx<Uint8List?>(null);

  void capture(CameraController controller) async {
    if (!controller.value.isTakingPicture) {
      try {
        await controller.setFlashMode(FlashMode.off);
        await controller.setFocusMode(FocusMode.auto);
        image.value = await controller.takePicture();
        if (image != '') {
          // sendID();
          loading.value = true;
          Future.delayed(const Duration(seconds: 2), () {
            idCard.text = '3411700830334';
            name.text = "บุญยัง โลเปซ";
            titleName.text = 'นาง';
            controller.pausePreview();
            loading.value = false;
            Get.back();
          });

          // Get.to(showImageScanner());
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Error: $e");
        }
      }
    }
  }

  Future<void> sendID() async {
    try {
      loading.value = true;
      var host = 'https://api.iapp.co.th/thai-national-id-card/v3/front';
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          image.value.path,
          filename: image.value.name,
        ),
      });

      Response response = await Dio().post(
        host,
        data: formData,
        options: Options(
          headers: {'apikey': 'HLVrnTW5K3uZPp8MOfzIDLVD5EH7LatL'},
        ),
      );

      if (response.statusCode == 200) {
        ID_Card thIDCard = ID_Card.fromJson(response.data);
        Uint8List imageFace = convert.base64Decode(thIDCard.face!);
        if (kDebugMode) {
          debugPrint("response: $response");
        }
        idCard.text = thIDCard.idNumber!;
        name.text = "${thIDCard.thFname} ${thIDCard.thLname}";
        titleName.text = thIDCard.thInit!;
        imageIDCard.value = imageFace;
        Get.back();
        // Get.back();
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      if (e.response != null) {
        handleErrorStatusOCR(e.response!.statusCode).then(
          (value) {
            dialogOnebutton_Subtitle(
                title: 'occur_error'.tr,
                subtitle: value,
                icon: Icons.warning,
                colorIcon: Colors.orange,
                textButton: 'OK',
                press: () {
                  Get.back();
                  Get.back();
                },
                click: false,
                backBtn: false,
                willpop: false);
          },
        );
      } else {
        error_Connected(() {
          Get.back();
          Get.back();
        });
      }
    } finally {
      loading.value = false;
    }
  }
}
