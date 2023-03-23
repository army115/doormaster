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
    return Card(
      child: Stack(
        // alignment: Alignment.topLeft,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            width: widget.width,
            height: widget.height,
            child: widget.lat == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
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
                child: IconButton(
                    constraints: BoxConstraints(),
                    onPressed: () => setState(() {
                          _mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(
                                LatLng(widget.lat, widget.lng), 20),
                          );
                        }),
                    icon: Icon(
                      Icons.my_location_rounded,
                      color: Colors.grey[800],
                    )),
              ),
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
                child: IconButton(
                    constraints: BoxConstraints(),
                    onPressed: () => setState(() {
                          maptype = (maptype == MapType.normal)
                              ? MapType.hybrid
                              : MapType.normal;
                        }),
                    icon: Icon(
                      Icons.map,
                      color: Colors.grey[800],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
