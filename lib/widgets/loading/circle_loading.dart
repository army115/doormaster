import 'package:flutter/material.dart';

class CircleLoading extends StatelessWidget {
  Color? color;
  Color? backgroundColor;
  double? strokeAlign;
  double? strokeWidth;
  double? value;
  CircleLoading({
    super.key,
    this.color,
    this.backgroundColor,
    this.strokeAlign,
    this.strokeWidth,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        backgroundColor: backgroundColor,
        strokeAlign: strokeAlign ?? 1,
        strokeWidth: strokeWidth ?? 4,
        value: value,
      ),
    );
  }
}
