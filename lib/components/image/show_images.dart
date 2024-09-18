// ignore_for_file: non_constant_identifier_names

import 'package:doormster/components/button/button_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';
import 'package:get/get.dart';

import '../../service/connected/ip_address.dart';

Widget showImage({required image, required onPrass}) {
  return Card(
    elevation: 5,
    margin: const EdgeInsets.symmetric(vertical: 10),
    color: Colors.transparent,
    child: Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageDomain + image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  SizedBox(height: 170, child: imageEror()),
            )),
        closeButton(radius: 15, onPress: onPrass)
      ],
    ),
  );
}

Widget NoImage() {
  return Stack(
    children: [
      Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            Icons.image_not_supported_rounded,
            size: 50,
          ),
          Text('no_picture'.tr)
        ]),
      ),
    ],
  );
}

Widget imageEror() {
  return Container(
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(
        Icons.broken_image_rounded,
        size: 50,
      ),
      Text('image_error'.tr)
    ]),
  );
}

Widget OneImage(listImages, bool closebutton) {
  return Stack(
    children: [
      ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: listImages == null || listImages == ''
              ? NoImage()
              : Image.network('$imageDomain$listImages', loadingBuilder:
                  (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                }, errorBuilder: (context, error, stackTrace) {
                  print(error);
                  return imageEror();
                })),
      closebutton == true
          ? closeButton(radius: 18, onPress: () => Get.back())
          : Container(),
    ],
  );
}

Widget ListImage(listImages, bool closebutton) {
  return Stack(
    children: [
      Swiper(
        loop: false,
        pagination: const SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                size: 8,
                activeSize: 8,
                color: Colors.grey,
                activeColor: Colors.white)),
        control: const SwiperControl(
            color: Colors.white,
            iconPrevious: Icons.arrow_back_ios_new_rounded,
            iconNext: Icons.arrow_forward_ios_rounded),
        itemCount: listImages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: listImages.isEmpty
                    ? NoImage()
                    : Image.network('$imageDomain${listImages[index].imgPath}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                        print(error);
                        return imageEror();
                      })),
          );
        },
      ),
      closebutton == true
          ? closeButton(radius: 18, onPress: () => Get.back())
          : Container(),
    ],
  );
}
