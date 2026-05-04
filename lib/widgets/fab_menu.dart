import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/node_model.dart';
import '../utils/colors.dart';
import 'glass.dart';

class FabMenu extends StatefulWidget {
  final ValueChanged<NodeType> onAdd;
  const FabMenu({super.key, required this.onAdd});
  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 280));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _open = !_open);
    if (_open) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _toggle,
            ),
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _itemAnim(0, _option('Сообщение', AppColors.nodeMessage,
                'assets/icons/chat-round-bold.svg', () {
              widget.onAdd(NodeType.message);
              _toggle();
            })),
            const SizedBox(height: 12),
            _itemAnim(1, _option('Заметка', AppColors.accent5,
                'assets/icons/notes-bold.svg', () {
              widget.onAdd(NodeType.note);
              _toggle();
            })),
            const SizedBox(height: 16),
            _fab(),
          ],
        ),
      ],
    );
  }

  Widget _itemAnim(int idx, Widget child) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final t = Curves.easeOutBack.transform(
            (_ctrl.value - idx * 0.08).clamp(0.0, 1.0));
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 16),
            child: Transform.scale(
              scale: 0.9 + 0.1 * t,
              alignment: Alignment.centerRight,
              child: IgnorePointer(ignoring: !_open, child: child),
            ),
          ),
        );
      },
    );
  }

  Widget _option(
      String label, Color color, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Glass(
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 12),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(icon,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fab() {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedRotation(
        turns: _open ? 0.125 : 0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutBack,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 10),
              )
            ],
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            'assets/icons/add-square-bold.svg',
            width: 28,
            height: 28,
            colorFilter:
                const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
