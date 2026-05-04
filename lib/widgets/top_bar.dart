import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: _Logo(),
        ),
        const Spacer(),
        _IconBtn(icon: Icons.crop_free_rounded, onTap: () {}),
        const SizedBox(width: 10),
        _IconBtn(icon: Icons.ios_share_rounded, onTap: () {}),
      ],
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
          shadows: [
            Shadow(color: Color(0x8C000000), blurRadius: 14, offset: Offset(0, 1)),
          ],
        ),
        children: [
          TextSpan(text: 'Bot Flow ', style: TextStyle(color: AppColors.accent)),
          TextSpan(
            text: 'Builder',
            style: TextStyle(color: AppColors.textDim, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _pressed
                ? const Color(0xEB414141)
                : const Color(0xD1282828),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0x1AFFFFFF)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4D000000),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Icon(widget.icon, color: AppColors.text, size: 20),
        ),
      ),
    );
  }
}
