import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/node_model.dart';
import '../utils/colors.dart';

class NodeEditorSheet extends StatefulWidget {
  final FlowNode node;
  final ValueChanged<FlowNode> onSave;
  final VoidCallback onDelete;
  const NodeEditorSheet({
    super.key,
    required this.node,
    required this.onSave,
    required this.onDelete,
  });

  static Future<void> show(BuildContext context, FlowNode node,
      {required ValueChanged<FlowNode> onSave,
      required VoidCallback onDelete}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => NodeEditorSheet(
          node: node, onSave: onSave, onDelete: onDelete),
    );
  }

  @override
  State<NodeEditorSheet> createState() => _NodeEditorSheetState();
}

class _NodeEditorSheetState extends State<NodeEditorSheet> {
  late TextEditingController _title;
  late TextEditingController _text;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.node.title);
    _text = TextEditingController(text: widget.node.text);
  }

  @override
  void dispose() {
    _title.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNote = widget.node.type == NodeType.note;
    final accent = isNote ? AppColors.accent5 : AppColors.nodeMessage;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface2.withOpacity(0.92),
              border: Border(
                  top: BorderSide(
                      color: Colors.white.withOpacity(0.08), width: 1)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        isNote
                            ? 'assets/icons/notes-bold.svg'
                            : 'assets/icons/chat-round-bold.svg',
                        width: 20,
                        height: 20,
                        colorFilter:
                            ColorFilter.mode(accent, BlendMode.srcIn),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _title,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.text),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: widget.node.defaultTitle,
                          hintStyle:
                              const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                            'assets/icons/close-circle-bold.svg',
                            width: 18,
                            height: 18,
                            colorFilter: const ColorFilter.mode(
                                AppColors.text, BlendMode.srcIn)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.05), width: 1),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _text,
                    maxLines: 8,
                    minLines: 5,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.text, height: 1.45),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Введите текст…',
                      hintStyle: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onDelete();
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.accent2.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  'assets/icons/trash-bin-trash-bold.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(
                                      AppColors.accent2, BlendMode.srcIn)),
                              const SizedBox(width: 8),
                              const Text('Удалить',
                                  style: TextStyle(
                                      color: AppColors.accent2,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          widget.node.title = _title.text.trim();
                          widget.node.text = _text.text;
                          widget.onSave(widget.node);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text('Сохранить',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
