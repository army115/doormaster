import 'dart:io';

import 'package:flutter/material.dart';

Widget button_back(onpress) {
  return IconButton(
      icon: Platform.isIOS
          ? const Icon(Icons.arrow_back_ios_new_rounded)
          : const Icon(Icons.arrow_back),
      onPressed: onpress);
}
