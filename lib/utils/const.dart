import 'package:flutter/material.dart';
import 'package:game2248/domain/entities/gem_entity.dart';

/// Спрайты расчитаны на соотвествующую ширину и высоту.
const double maxWidth = 1080;
const double maxHeight = 1920;

/// Обычная скорость перемещения.
const double moveSpeed = 1000;

/// Скорость перемещения при падении вниз.
const double spawnSpeed = 3000;

const allGems = <GemEntity>[
  GemEntity(num: '1', color: Colors.red),
  GemEntity(num: '2', color: Colors.green),
  GemEntity(num: '4', color: Colors.blue),
  GemEntity(num: '8', color: Colors.yellow),
  GemEntity(num: '16', color: Colors.pink),
  GemEntity(num: '32', color: Colors.teal),
  GemEntity(num: '64', color: Colors.blueGrey),
  GemEntity(num: '128', color: Colors.deepOrangeAccent),
  GemEntity(num: '264', color: Colors.brown),
  GemEntity(num: '512', color: Colors.orange),
];
