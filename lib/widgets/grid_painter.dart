import 'package:flutter/material.dart';

class GridPainter extends CustomPainter {
  final Offset offset;
  final double scale;
  GridPainter({required this.offset, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..strokeWidth = 1;
    final step = 60.0 * scale;
    if (step < 6) return;
    final dx = offset.dx % step;
    final dy = offset.dy % step;
    for (double x = dx; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = dy; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) =>
      old.offset != offset || old.scale != scale;
}
