import 'dart:io';
import 'package:doormster/widgets/button/button_close.dart';
import 'package:doormster/controller/image_controller/add_images_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Add_Image extends StatelessWidget {
  final ImageSource? typeCamera;
  final String? title;
  final int count;
  Add_Image({super.key, this.typeCamera, this.title, required this.count});

  final listImages = addImagesController.listImage;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listImages.length < count
            ? listImages.length + 1
            : listImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: listImages.length == 1 && count == 1 ? 1 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          // index Images
          int actualIndex =
              addImagesController.listImage.length < count ? index - 1 : index;
          // reversed Index Images
          int reversedIndex =
              addImagesController.listImage.length - 1 - actualIndex;
          if (index == 0 && listImages.length < count) {
            return PhysicalModel(
              color: Colors.white,
              elevation: 5,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                  onTap: () {
                    if (typeCamera == null) {
                      addImagesController.selectType(
                        context,
                        title ?? 'add_image'.tr,
                      );
                    } else {
                      addImagesController.selectImages(typeCamera!);
                    }
                  },
                  child: const Icon(
                    Icons.add_a_photo,
                    size: 60,
                  )),
            );
          } else {
            return PhysicalModel(
              color: Colors.transparent,
              elevation: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(addImagesController.listImage[reversedIndex].path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )),
                  closeButton(
                      radius: 15,
                      onPress: () {
                        addImagesController.listImage.removeAt(reversedIndex);
                      }),
                ],
              ),
            );
          }
        },
      );
    });
  }
}
