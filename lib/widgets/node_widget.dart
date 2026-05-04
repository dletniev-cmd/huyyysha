import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/node_model.dart';
import '../utils/colors.dart';

class NodeWidget extends StatelessWidget {
  final FlowNode node;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  // connector callbacks (positions are local to node widget)
  final void Function(Offset globalPos)? onOutDragStart;
  final void Function(Offset globalPos)? onOutDragUpdate;
  final void Function(Offset globalPos)? onOutDragEnd;
  // for snapping highlight
  final bool inHighlight;

  const NodeWidget({
    super.key,
    required this.node,
    this.selected = false,
    this.onTap,
    this.onLongPress,
    this.onOutDragStart,
    this.onOutDragUpdate,
    this.onOutDragEnd,
    this.inHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    if (node.type == NodeType.note) return _buildNote(context);
    return _buildMessage(context);
  }

  Widget _buildMessage(BuildContext context) {
    final accent = node.accent;
    return _NodeShell(
      child: Container(
        constraints: const BoxConstraints(minWidth: 220, maxWidth: 280),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1D2A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected
                ? accent.withOpacity(0.55)
                : Colors.white.withOpacity(0.07),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(
                color: Color(0x73000000),
                blurRadius: 24,
                offset: Offset(0, 8)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/chat-round-bold.svg',
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('СООБЩЕНИЕ',
                            style: TextStyle(
                                fontSize: 9,
                                color: Color(0xB3FFFFFF),
                                letterSpacing: 1,
                                fontWeight: FontWeight.w500)),
                        Text(
                          node.title.isEmpty ? node.defaultTitle : node.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // body
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Text(
                node.text.isEmpty ? 'Нажмите, чтобы изменить…' : node.text,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  color: node.text.isEmpty
                      ? const Color(0x66FFFFFF)
                      : const Color(0xEBFFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNote(BuildContext context) {
    final colors = node.noteColors;
    final inner = Container(
      constraints: const BoxConstraints(minWidth: 200, maxWidth: 260),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
              color: Color(0x66000000),
              blurRadius: 32,
              offset: Offset(0, 14)),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.18), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset('assets/icons/notes-bold.svg',
                  width: 14,
                  height: 14,
                  colorFilter: const ColorFilter.mode(
                      Color(0xFF2A230A), BlendMode.srcIn)),
              const SizedBox(width: 6),
              Text(
                node.title.isEmpty ? node.defaultTitle : node.title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2A230A)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            node.text.isEmpty ? 'Заметка…' : node.text,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12, height: 1.45, color: Color(0xCC2A230A)),
          ),
        ],
      ),
    );
    return _NodeShell(
      rotate: -1.8,
      child: inner,
    );
  }
}

class _NodeShell extends StatelessWidget {
  final Widget child;
  final double rotate;
  const _NodeShell({required this.child, this.rotate = 0});
  @override
  Widget build(BuildContext context) {
    if (rotate == 0) return child;
    return Transform.rotate(angle: rotate * 3.1415926 / 180, child: child);
  }
}
