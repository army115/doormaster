import 'dart:io';

import 'package:flutter/material.dart';

Widget button_back(onpress) {
  return IconButton(
      icon: Platform.isIOS
          ? Icon(Icons.arrow_back_ios_new_rounded)
          : Icon(Icons.arrow_back),
      onPressed: onpress);
}
