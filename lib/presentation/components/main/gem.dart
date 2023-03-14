import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';
import 'package:game2248/domain/entities/gem_entity.dart';
import 'package:game2248/presentation/components/main/board_component.dart';
import 'package:game2248/presentation/game_2248.dart';

class Gem extends PositionComponent {
  static final gemSize = Vector2(170, 170);
  Vector2 _pos = Vector2.zero();
  final BoardComponent board;

  Gem(this.board);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gemSize;
    anchor = Anchor.center;
  }

  set pos(Vector2 val) {
    _pos = val;
  }

  Vector2 get pos => _pos;
}

class GemEmpty extends Gem {
  GemEmpty(super.board);
}

class GemNum extends Gem with HasGameRef<Game2248>, DragCallbacks {
  final GemEntity _config;
  late final SpriteComponent _sprite;

  GemNum(super.board, {required GemEntity config})
      : _config = config,
        super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final bg = await Sprite.load('png/gem.png');
    _sprite = SpriteComponent(sprite: bg);
    await add(_sprite);
    await _sprite.add(ColorEffect(
      _config.color,
      const Offset(1, 1),
      EffectController(duration: 0),
    ));
    final txt = TextComponent(
      text: _config.num,
      textRenderer:
          TextPaint(style: TextStyle(color: Colors.white, fontSize: _getFontSize(), fontWeight: FontWeight.bold)),
    );
    await add(txt);
    txt.position = size / 2 - txt.size / 2;
  }

  Future<void> move(Vector2 target, {double speed = 1000}) async {
    final completer = Completer<void>();
    await add(
      MoveToEffect(
        target,
        EffectController(speed: speed),
        onComplete: () {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    await completer.future;
  }

  double _getFontSize() {
    if (_config.num.length >= 4) {
      return 50;
    } else if (_config.num.length == 3) {
      return 70;
    } else if (_config.num.length == 2) {
      return 80;
    } else {
      return 90;
    }
  }

  GemEntity get config => _config;

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final found = gameRef.componentsAtPoint(event.devicePosition).whereType<GemNum>().toList();
    if (found.isNotEmpty) {
      board.onDragGem(this, found.first);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    board.onDragEnd();
  }
}
