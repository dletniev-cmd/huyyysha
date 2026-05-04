import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Капсула FAB слева снизу. Закрытое состояние — круг 48×48.
/// При тапе раскрывается вправо в капсулу с 5 иконками типов нод.
class FabMenu extends StatefulWidget {
  const FabMenu({super.key});

  @override
  State<FabMenu> createState() => _FabMenuState();
}

class _FabMenuState extends State<FabMenu> with SingleTickerProviderStateMixin {
  bool _open = false;

  static const _items = <_FabItem>[
    _FabItem(Icons.play_arrow_rounded, AppColors.accent3, 'start'),
    _FabItem(Icons.chat_bubble_rounded, AppColors.accent, 'message'),
    _FabItem(Icons.input_rounded, AppColors.accent3, 'input'),
    _FabItem(Icons.timer_rounded, AppColors.accent4, 'timer'),
    _FabItem(Icons.sticky_note_2_rounded, AppColors.accent5, 'comment'),
  ];

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    final panelW = 48.0 + _items.length * 42.0 + 12;
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        width: _open ? panelW : 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xF0161616),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: const [
            BoxShadow(color: Color(0x73000000), blurRadius: 24, offset: Offset(0, 8)),
          ],
        ),
        child: Stack(
          children: [
            // Кнопки появляются после открытия
            Positioned(
              left: 48,
              top: 4,
              bottom: 4,
              right: 8,
              child: AnimatedOpacity(
                opacity: _open ? 1 : 0,
                duration: Duration(milliseconds: _open ? 180 : 100),
                curve: Curves.easeOut,
                child: ClipRect(
                  child: Row(
                    children: [
                      for (int i = 0; i < _items.length; i++)
                        _AnimatedItem(
                          delay: Duration(milliseconds: _open ? 40 + i * 40 : 0),
                          visible: _open,
                          child: _AddNodeBtn(item: _items[i], onTap: () {}),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Плюс/крестик
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onTap: _toggle,
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: AnimatedRotation(
                      turns: _open ? 0.125 : 0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      child: const Icon(Icons.add_rounded,
                          color: AppColors.text, size: 26),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabItem {
  final IconData icon;
  final Color color;
  final String type;
  const _FabItem(this.icon, this.color, this.type);
}

class _AddNodeBtn extends StatefulWidget {
  final _FabItem item;
  final VoidCallback onTap;
  const _AddNodeBtn({required this.item, required this.onTap});
  @override
  State<_AddNodeBtn> createState() => _AddNodeBtnState();
}

class _AddNodeBtnState extends State<_AddNodeBtn> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _pressed ? const Color(0x1AFFFFFF) : Colors.transparent,
          ),
          child: Icon(widget.item.icon, color: widget.item.color, size: 20),
        ),
      ),
    );
  }
}

class _AnimatedItem extends StatelessWidget {
  final Duration delay;
  final bool visible;
  final Widget child;
  const _AnimatedItem({
    required this.delay,
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(visible),
      tween: Tween(begin: visible ? 0.0 : 1.0, end: visible ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, t, c) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 2),
            child: Transform.scale(scale: 0.6 + 0.4 * t, child: c),
          ),
        );
      },
      child: child,
    );
  }
}
