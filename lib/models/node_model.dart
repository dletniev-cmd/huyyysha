import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../utils/colors.dart';

enum NodeType { message, note }

class FlowNode {
  final String id;
  NodeType type;
  Offset position;
  String title;
  String text;
  int colorIndex; // for notes

  FlowNode({
    String? id,
    required this.type,
    required this.position,
    this.title = '',
    this.text = '',
    this.colorIndex = 0,
  }) : id = id ?? const Uuid().v4();

  String get defaultTitle =>
      type == NodeType.message ? 'Сообщение' : 'Заметка';

  Color get accent =>
      type == NodeType.message ? AppColors.nodeMessage : AppColors.accent5;

  List<Color> get noteColors =>
      AppColors.notePalette[colorIndex % AppColors.notePalette.length];
}

class FlowConnection {
  final String id;
  final String fromId;
  final String toId;
  FlowConnection({String? id, required this.fromId, required this.toId})
      : id = id ?? const Uuid().v4();
}
