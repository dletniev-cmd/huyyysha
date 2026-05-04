import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'glass.dart';
import 'svg_icon.dart';

/// FAB-капсулка: только две кнопки — заметка и сообщение, плюс кнопка-toggle.
class FabMenu extends StatefulWidget {
  final void Function(String type)? onAdd;
  const FabMenu({super.key, this.onAdd});

  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu> with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _ctl.forward();
    } else {
      _ctl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16 + bottom,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          child: Glass(
            borderRadius: BorderRadius.circular(34),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ToggleButton(open: _open, onTap: _toggle),
                ClipRect(
                  child: AnimatedBuilder(
                    animation: _ctl,
                    builder: (_, __) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: _ctl.value,
                        child: Opacity(
                          opacity: _ctl.value,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 6),
                              _ItemButton(
                                asset: 'chat',
                                color: AppColors.accent,
                                delay: 0,
                                progress: _ctl.value,
                                onTap: () { widget.onAdd?.call('message'); _toggle(); },
                              ),
                              const SizedBox(width: 8),
                              _ItemButton(
                                asset: 'note',
                                color: AppColors.accent5,
                                delay: 0.15,
                                progress: _ctl.value,
                                onTap: () { widget.onAdd?.call('comment'); _toggle(); },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final bool open;
  final VoidCallback onTap;
  const _ToggleButton({required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0x33000000),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: AnimatedRotation(
            turns: open ? 0.125 : 0, // 45°
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutBack,
            child: SvgIcon(open ? 'close' : 'plus', size: 26, color: AppColors.text),
          ),
        ),
      ),
    );
  }
}

class _ItemButton extends StatefulWidget {
  final String asset;
  final Color color;
  final double delay;
  final double progress;
  final VoidCallback onTap;
  const _ItemButton({
    required this.asset,
    required this.color,
    required this.delay,
    required this.progress,
    required this.onTap,
  });

  @override
  State<_ItemButton> createState() => _ItemButtonState();
}

class _ItemButtonState extends State<_ItemButton> {
  bool _down = false;
  @override
  Widget build(BuildContext context) {
    final t = ((widget.progress - widget.delay) / (1 - widget.delay)).clamp(0.0, 1.0);
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(20 * (1 - t), 0),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _down = true),
          onTapUp: (_) => setState(() => _down = false),
          onTapCancel: () => setState(() => _down = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _down ? 0.9 : 1.0,
            duration: const Duration(milliseconds: 120),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.18),
                shape: BoxShape.circle,
                border: Border.all(color: widget.color.withOpacity(0.45), width: 1),
              ),
              child: Center(
                child: SvgIcon(widget.asset, size: 22, color: widget.color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
