import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends GetxController {
  RxDouble lat = 0.0.obs;
  RxDouble lng = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      lat.value = position.latitude;
      lng.value = position.longitude;
    } catch (error) {
      debugPrint('Error getting location: $error');
    }
  }
}
