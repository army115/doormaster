// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_photos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final AddImagesController addImagesController = Get.put(AddImagesController());

class AddImagesController extends GetxController {
  final ImagePicker imgpicker = ImagePicker();
  RxList<XFile> listImage = <XFile>[].obs;

  Future selectType(context, title) async {
    showDialog(
      useRootNavigator: true,
      barrierDismissible: true,
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: const EdgeInsets.fromLTRB(30, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 16, letterSpacing: 0.5, fontWeight: FontWeight.bold),
        ),
        actions: [
          ListTile(
              title: Text('camera'.tr,
                  style: const TextStyle(fontSize: 15, letterSpacing: 0.5)),
              onTap: () {
                permissionCamere(
                    context, () => selectImages(ImageSource.camera));
                Get.back();
              }),
          ListTile(
            title: Text('photo'.tr,
                style: const TextStyle(fontSize: 15, letterSpacing: 0.5)),
            onTap: () {
              if (Platform.isIOS) {
                permissionPhotos(context, selectImages(ImageSource.gallery));
              } else {
                selectImages(ImageSource.gallery);
              }
              Get.back();
            },
          ),
          ListTile(
            title: Text('cancel'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.5,
                )),
            onTap: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> selectImages(ImageSource TypeImage) async {
    try {
      final XFile? pickedImages = await imgpicker.pickImage(
          source: TypeImage, maxHeight: 1080, maxWidth: 1080);
      if (pickedImages != null) {
        listImage.add(pickedImages);
      } else {
        if (kDebugMode) {
          debugPrint("No image is selected.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("error while picking file.");
      }
    }
  }
}
