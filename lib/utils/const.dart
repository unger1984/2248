import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game2248/domain/entities/gem_entity.dart';

/// Спрайты расчитаны на соотвествующую ширину и высоту.
const double maxWidth = 1080;
const double maxHeight = 1920;

/// Обычная скорость перемещения.
const double moveSpeed = 1000;

/// Скорость перемещения при падении вниз.
const double spawnSpeed = 3000;

final _random = Random();

Color getRandom() {
  return Colors.primaries[_random.nextInt(Colors.primaries.length)];
}

extension ToHuman on BigInt {
  String toHuman() {
    const suffix = ['k', 'm', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'];
    if (this < BigInt.from(1000)) return toString();
    for (var index = 0; index < suffix.length; index++) {
      var coef = pow(1000, index + 1);
      if (this / BigInt.from(coef) < 1000) {
        return '${this ~/ BigInt.from(coef)}${suffix.elementAt(index)}';
      }
    }

    return toString();
  }
}

final allGems = <GemEntity>[
  GemEntity(num: BigInt.from(2), color: getRandom()),
  GemEntity(num: BigInt.from(4), color: getRandom()),
  GemEntity(num: BigInt.from(8), color: getRandom()),
  GemEntity(num: BigInt.from(16), color: getRandom()),
  GemEntity(num: BigInt.from(32), color: getRandom()),
  GemEntity(num: BigInt.from(64), color: getRandom()),
  GemEntity(num: BigInt.from(128), color: getRandom()),
  GemEntity(num: BigInt.from(256), color: getRandom()),
  GemEntity(num: BigInt.from(512), color: getRandom()),
  GemEntity(num: BigInt.from(1024), color: getRandom()),
];
