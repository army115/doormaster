import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map_Page extends StatefulWidget {
  final lat;
  final lng;
  double width;
  double height;

  Map_Page({
    Key? key,
    this.lat,
    this.lng,
    required this.width,
    required this.height,
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
          markerId: MarkerId('id'),
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
          ? Center(
              child:
                  //   Image.asset(
                  //   'assets/images/pin.gif',
                  //   scale: 3,
                  // )
                  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading...')
                ],
              ),
            )
          : Stack(
              // alignment: Alignment.topLeft,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
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
                      //?     print(position.target);
                      //   });
                      // },
                      gestureRecognizers: {
                        //? เลื่อนแผนที่ใน ListView ไม่ให้หน้าจอเลื่อน
                        Factory<EagerGestureRecognizer>(
                            () => EagerGestureRecognizer())
                      },
                      // scrollGesturesEnabled: false,
                      mapType: maptype,
                      markers: _markers,
                      // myLocationButtonEnabled: true,
                      // myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.lat, widget.lng),
                        zoom: 20.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      }),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Opacity(
                    opacity: 0.7,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
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
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Opacity(
                    opacity: 0.7,
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        color: Colors.white,
                        child: InkWell(
                          onTap: () => setState(() {
                            maptype = (maptype == MapType.normal)
                                ? MapType.hybrid
                                : MapType.normal;
                          }),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(Icons.map,
                                size: 30, color: Colors.grey[800]),
                          ),
                        )),
                  ),
                ),
                // Positioned(
                //   left: 10,
                //   top: 60,
                //   child: Opacity(
                //     opacity: 0.7,
                //     child: Card(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(2)),
                //         color: Colors.white,
                //         child: InkWell(
                //           onTap: () {
                //             if (size == 'mini') {
                //               showFullMap();
                //             } else {
                //               Navigator.of(context, rootNavigator: true).pop();
                //             }
                //           },
                //           child: Icon(
                //               size == 'mini'
                //                   ? Icons.fullscreen_rounded
                //                   : Icons.fullscreen_exit_rounded,
                //               size: 40,
                //               color: Colors.grey[800]),
                //         )),
                //   ),
                // )
              ],
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
