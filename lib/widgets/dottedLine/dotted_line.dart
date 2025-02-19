import 'package:flutter/material.dart';

class DottedLine extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpace;
  final Color dashColor;
  final Color dashGapColor;

  const DottedLine({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.dashColor = Colors.black,
    this.dashGapColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: DottedLinePainter(dashWidth, dashSpace, dashColor, dashGapColor),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color dashColor;
  final Color dashGapColor;

  DottedLinePainter(
      this.dashWidth, this.dashSpace, this.dashColor, this.dashGapColor);

  @override
  void paint(Canvas canvas, Size size) {
    final dashPaint = Paint()
      ..color = dashColor
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke;

    final gapPaint = Paint()
      ..color = dashGapColor
      ..strokeWidth = size.height
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        dashPaint,
      );

      canvas.drawLine(
        Offset(startX + dashWidth, size.height / 2),
        Offset(startX + dashWidth + dashSpace, size.height / 2),
        gapPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
