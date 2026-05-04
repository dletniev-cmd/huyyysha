import 'package:flutter/material.dart';
import '../models/node_model.dart';

class ConnectionsPainter extends CustomPainter {
  final List<FlowConnection> connections;
  final Map<String, Offset> outPoints; // bottom-center of node (world coords)
  final Map<String, Offset> inPoints; // top-center of node (world coords)
  final Offset canvasOffset;
  final double scale;
  // pending drag connection
  final Offset? dragFrom;
  final Offset? dragTo;
  final Color dragColor;

  ConnectionsPainter({
    required this.connections,
    required this.outPoints,
    required this.inPoints,
    required this.canvasOffset,
    required this.scale,
    this.dragFrom,
    this.dragTo,
    this.dragColor = const Color(0xFFA5A1FF),
  });

  Offset _toScreen(Offset world) => world * scale + canvasOffset;

  void _drawCurve(Canvas c, Offset a, Offset b, Color color, double width) {
    final path = Path();
    path.moveTo(a.dx, a.dy);
    final dy = (b.dy - a.dy).abs().clamp(40.0, 220.0);
    path.cubicTo(a.dx, a.dy + dy * 0.5, b.dx, b.dy - dy * 0.5, b.dx, b.dy);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    c.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final conn in connections) {
      final a = outPoints[conn.fromId];
      final b = inPoints[conn.toId];
      if (a == null || b == null) continue;
      _drawCurve(canvas, _toScreen(a), _toScreen(b),
          const Color(0xFFA5A1FF).withOpacity(0.85), 2.2 * scale.clamp(0.6, 2));
    }
    if (dragFrom != null && dragTo != null) {
      _drawCurve(canvas, _toScreen(dragFrom!), dragTo!, dragColor, 2.2);
      // dot at end
      canvas.drawCircle(dragTo!, 6, Paint()..color = dragColor);
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionsPainter old) => true;
}
