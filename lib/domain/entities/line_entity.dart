import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LineEntity {
  final Color color;
  final Vector2 start;
  final Vector2 end;

  const LineEntity({
    required this.color,
    required this.start,
    required this.end,
  });
}
