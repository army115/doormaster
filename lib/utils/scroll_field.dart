import 'package:flutter/material.dart';

void scrollToField(GlobalKey key) {
  Scrollable.ensureVisible(
    key.currentContext!,
    duration: const Duration(milliseconds: 300),
    alignment: 0.5,
  );
}
