import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Бесконечный canvas с сеткой, pan + pinch zoom.
/// Сетка рисуется в координатах экрана и сдвигается через background-position
/// (как в исходной HTML-версии): минимальный repaint.
class CanvasView extends StatefulWidget {
  final ValueChanged<double>? onZoomChanged;
  const CanvasView({super.key, this.onZoomChanged});

  @override
  State<CanvasView> createState() => _CanvasViewState();
}

class _CanvasViewState extends State<CanvasView> {
  Offset _offset = Offset.zero;
  double _scale = 1.0;

  // gesture state
  Offset _startFocal = Offset.zero;
  Offset _startOffset = Offset.zero;
  double _startScale = 1.0;

  void _onStart(ScaleStartDetails d) {
    _startFocal = d.focalPoint;
    _startOffset = _offset;
    _startScale = _scale;
  }

  void _onUpdate(ScaleUpdateDetails d) {
    final newScale = (_startScale * d.scale).clamp(0.25, 3.0);
    // якорим зум вокруг focal
    final focal = d.focalPoint;
    final dx = focal.dx - _startFocal.dx;
    final dy = focal.dy - _startFocal.dy;

    // мировая точка под фокусом в момент начала
    final worldX = (_startFocal.dx - _startOffset.dx) / _startScale;
    final worldY = (_startFocal.dy - _startOffset.dy) / _startScale;

    final newOffsetX = focal.dx - worldX * newScale + 0 * dx;
    final newOffsetY = focal.dy - worldY * newScale + 0 * dy;

    setState(() {
      _scale = newScale;
      _offset = Offset(newOffsetX, newOffsetY);
    });
    widget.onZoomChanged?.call(_scale);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onScaleStart: _onStart,
      onScaleUpdate: _onUpdate,
      child: Container(
        color: AppColors.bg,
        child: CustomPaint(
          painter: _GridPainter(offset: _offset, scale: _scale),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Offset offset;
  final double scale;
  _GridPainter({required this.offset, required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    // фон
    final bgPaint = Paint()..color = AppColors.bg;
    canvas.drawRect(Offset.zero & size, bgPaint);

    // сетка: 40px шаг в мировых координатах
    const baseStep = 40.0;
    final step = baseStep * scale;
    if (step < 6) return; // не рисуем слишком мелкую

    final dotPaint = Paint()..color = const Color(0xFF1A1A1A);
    final majorPaint = Paint()..color = const Color(0xFF222222);

    final startX = offset.dx % step;
    final startY = offset.dy % step;

    // мажорные линии каждые 5 шагов
    final majorStep = step * 5;
    final majorStartX = offset.dx % majorStep;
    final majorStartY = offset.dy % majorStep;

    final linePaint = Paint()
      ..color = const Color(0xFF141414)
      ..strokeWidth = 1;

    for (double x = startX; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    for (double y = startY; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    final majorLinePaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..strokeWidth = 1;
    for (double x = majorStartX; x < size.width; x += majorStep) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), majorLinePaint);
    }
    for (double y = majorStartY; y < size.height; y += majorStep) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), majorLinePaint);
    }

    // точки на пересечениях мажорных
    for (double x = majorStartX; x < size.width; x += majorStep) {
      for (double y = majorStartY; y < size.height; y += majorStep) {
        canvas.drawCircle(Offset(x, y), 1.2, dotPaint);
      }
    }
    // лёгкое затемнение на мелких пересечениях
    for (double x = startX; x < size.width; x += step) {
      for (double y = startY; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 0.6, majorPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) =>
      old.offset != offset || old.scale != scale;
}
