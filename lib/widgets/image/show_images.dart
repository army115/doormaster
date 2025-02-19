// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doormster/widgets/button/button_close.dart';
import 'package:doormster/widgets/loading/image_loading.dart';
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
                  SizedBox(height: 170, child: imageError()),
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
        child: Opacity(
          opacity: 0.5,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.image_not_supported_rounded,
              size: 40,
              color: Colors.grey[900],
            ),
            Text(
              'no_picture'.tr,
              style: TextStyle(color: Colors.grey[900]),
            )
          ]),
        ),
      ),
    ],
  );
}

Widget imageError() {
  return Container(
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white,
    ),
    child: Opacity(
      opacity: 0.5,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          Icons.error,
          size: 40,
          color: Colors.grey[900],
        ),
        Text(
          'image_error'.tr,
          style: TextStyle(
            color: Colors.grey[900],
          ),
        )
      ]),
    ),
  );
}

Widget OneImage(listImages, bool closebutton) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: listImages == null || listImages == ''
            ? NoImage()
            : CachedNetworkImage(
                imageUrl: '$imageDomain$listImages',
                useOldImageOnUrlChange: true,
                placeholder: (context, url) => const ImageLoading(),
                errorWidget: (context, url, error) {
                  debugPrint("error: $error");
                  return imageError();
                }),
      ),
      closebutton == true
          ? closeButton(radius: 18, onPress: () => Get.back())
          : Container(),
    ],
  );
}

Widget ListImage(List listImages, bool closebutton) {
  return Stack(
    children: [
      listImages.isEmpty
          ? NoImage()
          : Swiper(
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
                      child: CachedNetworkImage(
                          imageUrl: '$imageDomain${listImages[index].imgPath}',
                          useOldImageOnUrlChange: true,
                          placeholder: (context, url) => const ImageLoading(),
                          errorWidget: (context, url, error) {
                            debugPrint("error: $error");
                            return imageError();
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
