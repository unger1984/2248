import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Line extends Component {
  final List<Vector2> _points = [];

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (_points.length >= 2) {
      const color = Colors.white;
      final linePath = Path()..moveTo(_points.first.x, _points.first.y);
      final linePaint = Paint()..style = PaintingStyle.stroke;
      for (var i = 1; i < _points.length; i++) {
        final pos = _points[i];
        linePath.lineTo(pos.x, pos.y);
        linePaint.color = color;
        linePaint.strokeWidth = 20;
        canvas.drawPath(linePath, linePaint);
      }
    }
  }

  set points(List<Vector2> val) {
    _points.clear();
    _points.addAll(val);
    priority = 9999999;
  }
}
