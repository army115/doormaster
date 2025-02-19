// ignore_for_file: must_be_immutable, prefer_collection_literals, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map_Page extends StatefulWidget {
  final lat;
  final lng;
  final area_lat;
  final area_lng;
  final radius;
  bool myLocation;
  double width;
  double height;

  Map_Page({
    Key? key,
    required this.lat,
    required this.lng,
    this.area_lat,
    this.area_lng,
    required this.width,
    required this.height,
    required this.myLocation,
    this.radius,
  });

  @override
  State<Map_Page> createState() => _Map_PageState();
}

class _Map_PageState extends State<Map_Page> {
  Set<Marker> _markers = {};
  var maptype = MapType.normal;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    if (widget.lat != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('id'),
          position: LatLng(widget.lat, widget.lng),
          infoWindow: InfoWindow(title: '${widget.lat}, ${widget.lng}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return map(widget.width, widget.height, 'mini');
  }

  Widget map(width, height, size) {
    return Card(
      color: Colors.grey.shade100,
      child: widget.lat == null
          ? Container(
              margin: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text('Loading...')
                  ],
                ),
              ),
            )
          : Stack(
              // alignment: Alignment.topLeft,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  width: width,
                  height: height,
                  child: GoogleMap(
                      // onCameraMove: (position) {
                      //   setState(() {
                      //     //?เลื่อนหมุด
                      //?     _markers.add(Marker(
                      //?      markerId: MarkerId('new-location'),
                      //?      position: position.target,
                      //?     ));
                      //?     debugPrint(position.target);
                      //   });
                      // },
                      gestureRecognizers: {
                        //? เลื่อนแผนที่ใน ListView ไม่ให้หน้าจอเลื่อน
                        Factory<EagerGestureRecognizer>(
                            () => EagerGestureRecognizer())
                      },
                      // scrollGesturesEnabled: false,
                      mapType: maptype,
                      markers: widget.myLocation == false ? _markers : {},
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: false,
                      //สร้างวงกลมรัศมี
                      circles: widget.radius != null
                          ? // _buildCircles()
                          Set<Circle>.of([
                              Circle(
                                  circleId: const CircleId('1'),
                                  fillColor: Colors.green.withOpacity(0.5),
                                  center:
                                      LatLng(widget.area_lat, widget.area_lng),
                                  strokeColor: Colors.green,
                                  strokeWidth: 2,
                                  radius: widget.radius + .0)
                            ])
                          : {},
                      myLocationEnabled: widget.myLocation,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.lat, widget.lng),
                        zoom: 20.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      }),
                ),
                zoomControl(),
                mapStyle(),
                pinLocation()
              ],
            ),
    );
  }

  Widget zoomControl() {
    return Platform.isIOS
        ? Positioned(
            right: 10,
            bottom: 10,
            child: Opacity(
              opacity: 0.7,
              child: Column(
                children: [
                  Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => setState(() {
                          _mapController?.animateCamera(
                            CameraUpdate.zoomIn(),
                          );
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.add,
                              size: 30, color: Colors.grey[800]),
                        ),
                      )),
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () => setState(() {
                          _mapController?.animateCamera(
                            CameraUpdate.zoomOut(),
                          );
                        }),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(Icons.remove,
                              size: 30, color: Colors.grey[800]),
                        ),
                      ))
                ],
              ),
            ),
          )
        : Container();
  }

  Widget mapStyle() {
    return Positioned(
      left: 10,
      top: 10,
      child: Opacity(
        opacity: 0.7,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            color: Colors.white,
            child: InkWell(
              onTap: () => setState(() {
                maptype = (maptype == MapType.normal)
                    ? MapType.hybrid
                    : MapType.normal;
              }),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.map, size: 30, color: Colors.grey[800]),
              ),
            )),
      ),
    );
  }

  Widget pinLocation() {
    return Positioned(
      right: 10,
      top: 10,
      child: Opacity(
        opacity: 0.7,
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            color: Colors.white,
            child: InkWell(
              onTap: () => setState(() {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                      LatLng(widget.lat, widget.lng), 20),
                );
              }),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Icon(Icons.my_location_rounded,
                    size: 30, color: Colors.grey[800]),
              ),
            )),
      ),
    );
  }

  void showFullMap() {
    showDialog(
        useRootNavigator: true,
        // barrierDismissible: click,
        context: context,
        builder: (_) => Dialog(child: map(null, null, 'full')));
  }
}

Set<Circle> _buildCircles() {
  Set<Circle> circles = Set<Circle>();
  List<latlng> list_latlng = [
    latlng(lat: 13.695321842625534, lng: 100.64140477910816),
    latlng(lat: 13.695564638190184, lng: 100.64242752114824),
    latlng(lat: 13.695124009017109, lng: 100.6429689728165),
    latlng(lat: 13.69447205617483, lng: 100.64178425805514)
  ];
  for (var lat_lng in list_latlng) {
    circles.add(
      Circle(
        circleId: const CircleId('1'),
        center: LatLng(lat_lng.lat, lat_lng.lng),
        radius: 20,
        fillColor: Colors.blue.withOpacity(0.3),
        strokeWidth: 2,
        strokeColor: Colors.blue,
      ),
    );
  }
  debugPrint(circles.toString());

  return circles;
}

class latlng {
  double lat;
  double lng;
  latlng({required this.lat, required this.lng});
}
