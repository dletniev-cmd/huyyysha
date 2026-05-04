import 'package:flutter/material.dart';
import '../models/node_model.dart';
import '../utils/colors.dart';
import '../widgets/connections_painter.dart';
import '../widgets/fab_menu.dart';
import '../widgets/grid_painter.dart';
import '../widgets/node_context_menu.dart';
import '../widgets/node_editor_sheet.dart';
import '../widgets/node_widget.dart';
import '../widgets/top_bar.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});
  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  // viewport
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  // gesture state
  Offset? _lastFocal;
  double _gestureStartScale = 1.0;

  // model
  final List<FlowNode> _nodes = [];
  final List<FlowConnection> _connections = [];
  String? _draggingNodeId;
  Offset _nodeDragStartWorld = Offset.zero;
  Offset _nodeDragOriginPos = Offset.zero;

  // node sizes (measured at paint), so we can compute ports
  final Map<String, Size> _nodeSizes = {};

  // connection drag
  String? _connFromId;
  Offset? _connDragScreen;
  String? _hoverInId;

  @override
  void initState() {
    super.initState();
    // initial sample nodes
    _nodes.add(FlowNode(
      type: NodeType.message,
      position: const Offset(60, 120),
      title: 'Привет',
      text: 'Здравствуйте! Чем могу помочь?',
    ));
    _nodes.add(FlowNode(
      type: NodeType.note,
      position: const Offset(60, 320),
      colorIndex: 0,
      title: 'Идея',
      text: 'Не забыть добавить ветку для продаж',
    ));
  }

  // world <-> screen
  Offset _toScreen(Offset w) => w * _scale + _offset;
  Offset _toWorld(Offset s) => (s - _offset) / _scale;

  // ports (world coords)
  Offset _outPort(FlowNode n) {
    final size = _nodeSizes[n.id] ?? const Size(240, 120);
    return n.position + Offset(size.width / 2, size.height + 6);
  }

  Offset _inPort(FlowNode n) {
    final size = _nodeSizes[n.id] ?? const Size(240, 120);
    return n.position + Offset(size.width / 2, -6);
  }

  // tests if screen point hits in-port of any node
  String? _hitInPort(Offset screen) {
    const radius = 28.0;
    for (final n in _nodes) {
      final p = _toScreen(_inPort(n));
      if ((p - screen).distance <= radius) return n.id;
    }
    return null;
  }

  String? _hitNodeBottomConnector(Offset screen) {
    const radius = 28.0;
    for (final n in _nodes.reversed) {
      final p = _toScreen(_outPort(n));
      if ((p - screen).distance <= radius) return n.id;
    }
    return null;
  }

  String? _hitNode(Offset screen) {
    for (final n in _nodes.reversed) {
      final size = _nodeSizes[n.id] ?? const Size(240, 120);
      final tl = _toScreen(n.position);
      final br = _toScreen(n.position + Offset(size.width, size.height));
      final r = Rect.fromPoints(tl, br);
      if (r.contains(screen)) return n.id;
    }
    return null;
  }

  void _addNode(NodeType type) {
    final center = MediaQuery.of(context).size.center(Offset.zero);
    final world = _toWorld(center);
    setState(() {
      _nodes.add(FlowNode(
        type: type,
        position: world - const Offset(120, 60),
        colorIndex: type == NodeType.note
            ? (_nodes.where((n) => n.type == NodeType.note).length %
                AppColors.notePalette.length)
            : 0,
      ));
    });
  }

  void _openEditor(FlowNode n) {
    NodeEditorSheet.show(context, n,
        onSave: (updated) => setState(() {}),
        onDelete: () => setState(() {
              _nodes.removeWhere((x) => x.id == n.id);
              _connections
                  .removeWhere((c) => c.fromId == n.id || c.toId == n.id);
            }));
  }

  void _showContextMenu(FlowNode n, Offset screenPos) {
    NodeContextMenu.show(
      context,
      position: screenPos,
      onEdit: () => _openEditor(n),
      onDuplicate: () => setState(() {
        _nodes.add(FlowNode(
          type: n.type,
          position: n.position + const Offset(24, 24),
          title: n.title,
          text: n.text,
          colorIndex: n.colorIndex,
        ));
      }),
      onDelete: () => setState(() {
        _nodes.removeWhere((x) => x.id == n.id);
        _connections
            .removeWhere((c) => c.fromId == n.id || c.toId == n.id);
      }),
    );
  }

  // ---- gestures on canvas ----
  void _onScaleStart(ScaleStartDetails d) {
    _lastFocal = d.focalPoint;
    _gestureStartScale = _scale;
    final hitOut = _hitNodeBottomConnector(d.focalPoint);
    if (hitOut != null) {
      _connFromId = hitOut;
      _connDragScreen = d.focalPoint;
      setState(() {});
      return;
    }
    final hit = _hitNode(d.focalPoint);
    if (hit != null) {
      _draggingNodeId = hit;
      _nodeDragStartWorld = _toWorld(d.focalPoint);
      _nodeDragOriginPos = _nodes.firstWhere((n) => n.id == hit).position;
    }
  }

  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (_connFromId != null) {
      _connDragScreen = d.focalPoint;
      _hoverInId = _hitInPort(d.focalPoint);
      if (_hoverInId == _connFromId) _hoverInId = null;
      setState(() {});
      return;
    }
    if (_draggingNodeId != null && d.scale == 1.0) {
      final world = _toWorld(d.focalPoint);
      final delta = world - _nodeDragStartWorld;
      final n = _nodes.firstWhere((x) => x.id == _draggingNodeId);
      n.position = _nodeDragOriginPos + delta;
      setState(() {});
      return;
    }
    // pan / zoom
    if (d.scale != 1.0) {
      final newScale = (_gestureStartScale * d.scale).clamp(0.4, 2.5);
      // zoom around focal
      final focal = d.focalPoint;
      final worldBefore = (focal - _offset) / _scale;
      _scale = newScale;
      _offset = focal - worldBefore * _scale;
    } else if (_lastFocal != null) {
      _offset += d.focalPoint - _lastFocal!;
    }
    _lastFocal = d.focalPoint;
    setState(() {});
  }

  void _onScaleEnd(ScaleEndDetails d) {
    if (_connFromId != null) {
      if (_hoverInId != null && _hoverInId != _connFromId) {
        // avoid duplicates
        if (!_connections.any((c) =>
            c.fromId == _connFromId && c.toId == _hoverInId)) {
          _connections.add(
              FlowConnection(fromId: _connFromId!, toId: _hoverInId!));
        }
      }
      _connFromId = null;
      _connDragScreen = null;
      _hoverInId = null;
    }
    _draggingNodeId = null;
    _lastFocal = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // grid + interactions
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              onScaleEnd: _onScaleEnd,
              child: CustomPaint(
                painter: GridPainter(offset: _offset, scale: _scale),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          // connections layer
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: ConnectionsPainter(
                  connections: _connections,
                  outPoints: {for (final n in _nodes) n.id: _outPort(n)},
                  inPoints: {for (final n in _nodes) n.id: _inPort(n)},
                  canvasOffset: _offset,
                  scale: _scale,
                  dragFrom: _connFromId == null
                      ? null
                      : _outPort(
                          _nodes.firstWhere((n) => n.id == _connFromId)),
                  dragTo: _connDragScreen,
                ),
              ),
            ),
          ),
          // nodes
          ..._nodes.map(_buildNodePositioned),
          // in-port indicators (small dots) so user sees connect targets
          ..._nodes.map((n) {
            final p = _toScreen(_inPort(n));
            final highlight = _hoverInId == n.id;
            return Positioned(
              left: p.dx - 6,
              top: p.dy - 6,
              child: IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: highlight ? 16 : 12,
                  height: highlight ? 16 : 12,
                  decoration: BoxDecoration(
                    color: highlight
                        ? AppColors.accent3
                        : Colors.white.withOpacity(0.55),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.35), width: 1),
                  ),
                ),
              ),
            );
          }),
          // out-port indicators
          ..._nodes.map((n) {
            final p = _toScreen(_outPort(n));
            return Positioned(
              left: p.dx - 7,
              top: p.dy - 7,
              child: IgnorePointer(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: n.accent,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.35), width: 1),
                  ),
                ),
              ),
            );
          }),
          // top bar
          const Align(
            alignment: Alignment.topCenter,
            child: TopBar(),
          ),
          // fab
          Positioned(
            right: 18,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: FabMenu(onAdd: _addNode),
          ),
          // zoom badge
          Positioned(
            left: 16,
            bottom: 24 + MediaQuery.of(context).padding.bottom,
            child: AnimatedOpacity(
              opacity: 0.85,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.glassFill,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Text('${(_scale * 100).round()}%',
                    style: const TextStyle(
                        color: AppColors.textDim,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodePositioned(FlowNode n) {
    final screen = _toScreen(n.position);
    return Positioned(
      left: screen.dx,
      top: screen.dy,
      child: Transform.scale(
        scale: _scale,
        alignment: Alignment.topLeft,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _openEditor(n),
          onLongPressStart: (d) => _showContextMenu(n, d.globalPosition),
          child: _MeasureSize(
            onChange: (s) {
              if (_nodeSizes[n.id] != s) {
                _nodeSizes[n.id] = s;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() {});
                });
              }
            },
            child: NodeWidget(node: n),
          ),
        ),
      ),
    );
  }
}

class _MeasureSize extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onChange;
  const _MeasureSize({required this.child, required this.onChange});
  @override
  State<_MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<_MeasureSize> {
  final _key = GlobalKey();
  Size? _old;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _key.currentContext;
      if (ctx == null) return;
      final s = ctx.size;
      if (s != null && s != _old) {
        _old = s;
        widget.onChange(s);
      }
    });
    return SizedBox(key: _key, child: widget.child);
  }
}
