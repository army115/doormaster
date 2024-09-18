import 'package:flutter/material.dart';

Widget closeButton({required double radius, required onPress}) {
  return Positioned(
    top: 5,
    right: 5,
    child: CircleAvatar(
      radius: radius,
      backgroundColor: Colors.red,
      child: IconButton(
        padding: EdgeInsets.zero,
        // constraints: const BoxConstraints(),
        splashRadius: radius,
        icon: const Icon(Icons.close),
        onPressed: onPress,
        iconSize: 18,
        color: Colors.white,
      ),
    ),
  );
}
