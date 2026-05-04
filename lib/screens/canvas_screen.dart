import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/grid_painter.dart';
import '../widgets/top_bar.dart';
import '../widgets/fab_menu.dart';
import '../widgets/glass.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});
  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  Offset _offset = Offset.zero;
  double _scale = 1.24;
  Offset _startFocal = Offset.zero;
  Offset _startOffset = Offset.zero;
  double _startScale = 1.0;

  void _fit() {
    setState(() {
      _offset = Offset.zero;
      _scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          GestureDetector(
            onScaleStart: (d) {
              _startFocal = d.focalPoint;
              _startOffset = _offset;
              _startScale = _scale;
            },
            onScaleUpdate: (d) {
              setState(() {
                _scale = (_startScale * d.scale).clamp(0.4, 3.0);
                _offset = _startOffset + (d.focalPoint - _startFocal);
              });
            },
            child: CustomPaint(
              size: Size.infinite,
              painter: GridPainter(offset: _offset, scale: _scale),
              child: const SizedBox.expand(),
            ),
          ),
          TopBar(onFit: _fit, onExport: () {}),
          Positioned(
            right: 16,
            bottom: 90 + MediaQuery.of(context).padding.bottom,
            child: Glass(
              borderRadius: BorderRadius.circular(14),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                '${(_scale * 100).round()}%',
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          FabMenu(onAdd: (_) {}),
        ],
      ),
    );
  }
}
