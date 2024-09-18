import 'dart:io';

import 'package:doormster/service/permission/permission_camera.dart';
import 'package:doormster/service/permission/permission_photos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final AddImagesController addImagesController = Get.put(AddImagesController());

class AddImagesController extends GetxController {
  final ImagePicker imgpicker = ImagePicker();
  var listImage = <XFile>[].obs;

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
                Navigator.of(context, rootNavigator: true).pop();
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
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          ListTile(
            title: Text('cancel'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  letterSpacing: 0.5,
                )),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> selectImages(ImageSource TypeImage) async {
    try {
      // var pickedfiles = await imgpicker.pickMultiImage();
      final XFile? pickedImages = await imgpicker.pickImage(
          source: TypeImage, maxHeight: 1080, maxWidth: 1080);
      if (pickedImages != null) {
        // List<int> imageBytes = await pickedImages.readAsBytes();
        // var ImagesBase64 = convert.base64Encode(imageBytes);
        listImage.add(pickedImages);
        // listImage64?.add("data:image/png;base64,$ImagesBase64");
        // print('image: ${pickedImages.path}');
        // print('image64: ${ImagesBase64}');
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print("error while picking file.");
    }
  }
}
