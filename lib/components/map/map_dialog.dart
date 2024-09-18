// ignore_for_file: non_constant_identifier_names

import 'package:doormster/components/map/map_page.dart';
import 'package:flutter/material.dart';

void showMap_Dialog(
    {required BuildContext context,
    required double lat,
    required double lng,
    double? areaLat,
    double? areaLng,
    int? radius,
    required double vertical,
    required double horizontal}) {
  showDialog(
      useRootNavigator: true,
      context: context,
      builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.symmetric(
                vertical: vertical, horizontal: horizontal),
            child: Map_Page(
              width: double.infinity,
              height: double.infinity,
              lat: lat,
              lng: lng,
              area_lat: areaLat,
              area_lng: areaLng,
              myLocation: false,
              radius: radius,
            ),
          ));
}
