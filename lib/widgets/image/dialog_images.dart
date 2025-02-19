// ignore_for_file: non_constant_identifier_names

import 'package:doormster/widgets/image/show_images.dart';
import 'package:flutter/material.dart';

void showImages_Dialog({
  required context,
  required listImages,
}) {
  showDialog(
      useRootNavigator: true,
      context: context,
      builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding:
                const EdgeInsets.symmetric(vertical: 120, horizontal: 20),
            child: listImages is String
                ? OneImage(listImages, true)
                : ListImage(listImages, true),
          ));
}
