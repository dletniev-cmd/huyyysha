import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'glass.dart';
import 'svg_icon.dart';

class TopBar extends StatelessWidget {
  final VoidCallback? onFit;
  final VoidCallback? onExport;
  const TopBar({super.key, this.onFit, this.onExport});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Positioned(
      top: top + 10,
      left: 12,
      right: 12,
      height: 48,
      child: Row(
        children: [
          const _Logo(),
          const Spacer(),
          _GlassButton(asset: 'fullscreen', onTap: onFit),
          const SizedBox(width: 10),
          _GlassButton(asset: 'upload', onTap: onExport),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          shadows: [Shadow(blurRadius: 14, color: Color(0x8C000000))],
        ),
        children: [
          TextSpan(text: 'Bot Flow ', style: TextStyle(color: AppColors.accent)),
          TextSpan(text: 'Builder', style: TextStyle(color: AppColors.textDim, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _GlassButton extends StatefulWidget {
  final String asset;
  final VoidCallback? onTap;
  const _GlassButton({required this.asset, this.onTap});
  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Glass(
            borderRadius: BorderRadius.circular(22),
            child: Center(
              child: SvgIcon(widget.asset, size: 22, color: AppColors.text),
            ),
          ),
        ),
      ),
    );
  }
}
