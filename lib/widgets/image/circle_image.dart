// ignore_for_file: unnecessary_null_comparison, prefer_typing_uninitialized_variables
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doormster/service/connected/connect_api.dart';
import 'package:doormster/widgets/loading/circle_loading.dart';
import 'package:doormster/service/connected/ip_address.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class circleImage extends StatelessWidget {
  final List<XFile> fileImage;
  final imageProfile;
  final String typeImage;
  final VoidCallback? editImage;
  final double radiusCircle;
  final double borderSide;
  final Color? backgroundColor;
  final Icon iconImagenull;
  final Icon iconImageError;
  const circleImage(
      {super.key,
      required this.imageProfile,
      this.editImage,
      this.fileImage = const [],
      required this.radiusCircle,
      required this.typeImage,
      this.backgroundColor,
      required this.iconImagenull,
      required this.iconImageError,
      this.borderSide = 0});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.zero,
            shape: CircleBorder(
                side: BorderSide(width: borderSide, color: Colors.white)),
            child: CircleAvatar(
                radius: radiusCircle,
                backgroundColor: backgroundColor ?? Colors.grey.shade100,
                child: connectApi.loading.isTrue
                    ? CircleLoading()
                    : ClipOval(
                        child: fileImage.isNotEmpty
                            ? fileImageWidget()
                            : imageProfile != null && imageProfile != ''
                                ? typeImage == 'net'
                                    ? profileNetwork()
                                    : profileImage()
                                : iconImagenull,
                      )),
          ),
          editImage == null
              ? const SizedBox()
              : Positioned(
                  bottom: 0,
                  right: 5,
                  child: editButton(),
                )
        ],
      ),
    );
  }

  Widget fileImageWidget() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            fit: BoxFit.cover, image: FileImage(File(fileImage.last.path))),
      ),
    );
  }

  Widget profileNetwork() {
    return CachedNetworkImage(
      imageUrl: imageDomain + imageProfile!,
      useOldImageOnUrlChange: true,
      placeholder: (context, url) => CircleLoading(),
      errorWidget: (context, url, error) => iconImageError,
    );
  }

  Widget profileImage() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(imageProfile),
          onError: (exception, stackTrace) => iconImageError,
        ),
      ),
    );
  }

  Widget editButton() {
    return Card(
        elevation: 5,
        shape: const CircleBorder(
            side: BorderSide(color: Colors.white, width: 2.5)),
        child: CircleAvatar(
            radius: 21,
            backgroundColor: Get.theme.primaryColor,
            child: IconButton(
              splashRadius: 20,
              onPressed: editImage,
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            )));
  }
}
