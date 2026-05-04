import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/colors.dart';
import 'glass.dart';

class NodeContextMenu extends StatelessWidget {
  final Offset position;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const NodeContextMenu({
    super.key,
    required this.position,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
  });

  static Future<void> show(
    BuildContext context, {
    required Offset position,
    required VoidCallback onEdit,
    required VoidCallback onDuplicate,
    required VoidCallback onDelete,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'menu',
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, __, ___) => NodeContextMenu(
        position: position,
        onEdit: onEdit,
        onDuplicate: onDuplicate,
        onDelete: onDelete,
      ),
      transitionBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
        return Opacity(
          opacity: anim.value,
          child: Transform.scale(
            scale: 0.85 + 0.15 * curved.value,
            alignment: Alignment.topLeft,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final left = position.dx.clamp(12.0, size.width - 200);
    final top = position.dy.clamp(60.0, size.height - 200);
    return Stack(
      children: [
        Positioned(
          left: left,
          top: top,
          child: Glass(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 200,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _item('assets/icons/pen-bold.svg', 'Редактировать',
                      AppColors.text, () {
                    Navigator.of(context).pop();
                    onEdit();
                  }),
                  _item('assets/icons/copy-bold.svg', 'Дублировать',
                      AppColors.text, () {
                    Navigator.of(context).pop();
                    onDuplicate();
                  }),
                  Container(height: 1, color: Colors.white.withOpacity(0.06)),
                  _item('assets/icons/trash-bin-trash-bold.svg', 'Удалить',
                      AppColors.accent2, () {
                    Navigator.of(context).pop();
                    onDelete();
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _item(String icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              SvgPicture.asset(icon,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
              const SizedBox(width: 12),
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
