import 'package:flutter/material.dart';

Widget myScrollScreen(Widget child) {
  return ScrollConfiguration(
    // scroll listview screen
    behavior: const ScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics())),
    child: child,
  );
}
