// ignore_for_file: must_be_immutable

import 'package:doormster/service/connected/connect_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget Button_Animation({required title, required press}) {
  return GestureDetector(
    onTap: press,
    child: Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(connectApi.loading.isTrue ? 25 : 10),
      color: Get.theme.primaryColor,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width:
            connectApi.loading.isTrue ? 50 : Get.mediaQuery.size.width * 0.55,
        height: 50,
        alignment: Alignment.center,
        child: connectApi.loading.isTrue
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 1,
                ),
              ),
      ),
    ),
  );
}
