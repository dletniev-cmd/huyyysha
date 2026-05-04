import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class GridPainter extends CustomPainter {
  final Offset offset;
  final double scale;
  GridPainter({required this.offset, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.bg);
    const baseStep = 28.0;
    final step = baseStep * scale;
    if (step < 6) return;
    final paint = Paint()
      ..color = AppColors.bgGrid
      ..strokeWidth = 1;
    final dotPaint = Paint()..color = const Color(0xFF1A1A1A);
    final startX = (offset.dx % step);
    final startY = (offset.dy % step);
    for (double x = startX; x < size.width; x += step) {
      for (double y = startY; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), math.max(0.6, scale * 0.9), dotPaint);
      }
    }
    // ignore line painter to avoid noise
    paint.color = paint.color;
  }

  @override
  bool shouldRepaint(covariant GridPainter old) =>
      old.offset != offset || old.scale != scale;
}
