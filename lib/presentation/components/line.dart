import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game2248/domain/entities/line_entity.dart';

class Line extends Component {
  final List<LineEntity> _lines = [];

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (var line in _lines) {
      final color = line.color;
      final start = line.start;
      final end = line.end;

      final linePath = Path()
        ..moveTo(start.x, start.y)
        ..lineTo(end.x, end.y);
      final linePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 30
        ..color = color;
      canvas.drawPath(linePath, linePaint);
    }
  }

  set points(List<LineEntity> val) {
    _lines.clear();
    _lines.addAll(val);
  }
}
