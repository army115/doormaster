import 'package:flutter/material.dart';

Widget myScrollScreen(Widget child) {
  return ScrollConfiguration(
    // scroll listview screen การเลื่อนไลด์หน้าแอพ
    behavior: ScrollBehavior().copyWith(
        // Set the default scroll physics here
        physics: BouncingScrollPhysics()
        // Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics(),
        ),
    child: child,
  );
}
