import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/canvas_view.dart';
import '../widgets/top_bar.dart';
import '../widgets/fab_menu.dart';

class BuilderScreen extends StatefulWidget {
  const BuilderScreen({super.key});

  @override
  State<BuilderScreen> createState() => _BuilderScreenState();
}

class _BuilderScreenState extends State<BuilderScreen> {
  double _zoom = 1.0;
  bool _showZoomLabel = false;

  void _onZoomChanged(double z) {
    setState(() {
      _zoom = z;
      _showZoomLabel = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // CANVAS
          Positioned.fill(
            child: CanvasView(onZoomChanged: _onZoomChanged),
          ),

          // Градиентная вуаль сверху (как #topbar-blur)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 88 + mq.padding.top,
            child: IgnorePointer(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xE0000000),
                      Color(0xB8000000),
                      Color(0x73000000),
                      Color(0x00000000),
                    ],
                    stops: [0, 0.35, 0.65, 1],
                  ),
                ),
              ),
            ),
          ),

          // TOP BAR
          Positioned(
            top: 10 + mq.padding.top,
            left: 12,
            right: 12,
            height: 48,
            child: const TopBar(),
          ),

          // ZOOM label (правый нижний угол)
          Positioned(
            right: 16,
            bottom: 80 + mq.padding.bottom,
            child: AnimatedOpacity(
              opacity: _showZoomLabel ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xCC161616),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${(_zoom * 100).round()}%',
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // FAB
          Positioned(
            left: 0,
            bottom: 20 + mq.padding.bottom,
            child: const FabMenu(),
          ),
        ],
      ),
    );
  }
}
