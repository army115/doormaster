import 'package:flutter/material.dart';

ButtonStyle styleButtons(padding, elevation, backgroundColor, shape) {
  return ButtonStyle(
    padding: MaterialStateProperty.all(padding),
    elevation: MaterialStateProperty.all(elevation),
    backgroundColor: MaterialStateProperty.all(backgroundColor),
    overlayColor: MaterialStateProperty.all(Colors.black12),
    shape:
        MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: shape)),
  );
}
