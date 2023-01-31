import 'package:flutter/material.dart';

class MenuItem {
  int icons;
  String name;
  String page;
  MenuItem(this.icons, this.name, this.page);
}

List<MenuItem> Menu = [
  MenuItem(0xf00cb, 'QR Smart', '/qrsmart'),
  MenuItem(0xf61a, 'parcel', '/parcel'),
  MenuItem(0xf89e, 'managemant', '/managemant'),
  MenuItem(0xf0630, 'security', '/security'),
  MenuItem(0xf02e2, 'visitor', '/visitor'),
];
