import 'dart:async';

import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:game2248/domain/entities/gem_entity.dart';
import 'package:game2248/presentation/game2248.dart';
import 'package:game2248/utils/const.dart';

class Gem extends PositionComponent {
  static final gemSize = Vector2(170, 170);
  Vector2 pos = Vector2.zero();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = gemSize;
    anchor = Anchor.center;
  }
}

class GemEmpty extends Gem {}

class GemNum extends Gem with HasGameRef<Game2248> {
  final GemEntity _config;
  late final SpriteComponent bgSprite;
  late final TextComponent txt;

  GemNum({required GemEntity config})
      : _config = config,
        super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final bg = await Sprite.load('png/gem.png');
    bgSprite = SpriteComponent(sprite: bg);
    await add(bgSprite);
    await bgSprite.add(ColorEffect(
      _config.color,
      EffectController(duration: 0),
      // const Offset(1, 1),
      // EffectController(duration: 0),
    ));
    txt = TextComponent(
      text: _config.num.toHuman(),
      textRenderer:
          TextPaint(style: TextStyle(color: Colors.white, fontSize: _getFontSize(), fontWeight: FontWeight.bold)),
    );
    await add(txt);
    txt.position = size / 2 - txt.size / 2;
    // exploseSprite = SpriteAnimationComponent(sprite: explose)
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
    if (_config.num.toHuman().length >= 4) {
      return 50;
    } else if (_config.num.toHuman().length == 3) {
      return 70;
    } else if (_config.num.toHuman().length == 2) {
      return 80;
    } else {
      return 90;
    }
  }

  GemEntity get config => _config;

  Future<void> destroy(Vector2 pos) async {
    final completer = Completer<void>();
    await add(
      MoveToEffect(
        pos,
        EffectController(speed: 1000),
        onComplete: () {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    await add(
      ScaleEffect.to(
        Vector2.all(0.1),
        EffectController(duration: 0.3),
      ),
    );
    await completer.future;
  }

  Future<void> spawn() async {
    remove(bgSprite);
    remove(txt);

    final explose = await Images().load('png/explose.png');
    final data = SpriteAnimationData.sequenced(
      textureSize: Vector2.all(256),
      amount: 10,
      stepTime: 0.05,
      loop: false,
    );
    SpriteAnimationComponent exploseSprite = SpriteAnimationComponent.fromFrameData(
      explose,
      data,
      playing: false,
      removeOnFinish: true,
    );
    exploseSprite.position = size / 2 - exploseSprite.size / 2;

    await add(exploseSprite);
    exploseSprite.add(ColorEffect(_config.color, EffectController(duration: 0)));
    final ticker = exploseSprite.animationTicker;
    exploseSprite.playing = true;
    await ticker?.completed;
  }

  Future<void> handleHilight() async {
    final completer = Completer<void>();
    await add(
      SequenceEffect(
        [
          ScaleEffect.to(
            Vector2.all(1.4),
            EffectController(duration: 0.1),
          ),
          ScaleEffect.to(
            Vector2.all(1),
            EffectController(duration: 0.1),
          ),
          ScaleEffect.to(
            Vector2.all(1.1),
            EffectController(duration: 0.1),
          ),
          ScaleEffect.to(
            Vector2.all(1),
            EffectController(duration: 0.1),
          ),
        ],
        onComplete: () {
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );
    await completer.future;
  }

  // @override
  // void onDragUpdate(DragUpdateEvent event) {
  //   final found = gameRef.componentsAtPoint(event.devicePosition).whereType<GemNum>().toList();
  //   if (found.isNotEmpty) {
  //     board.onDragGem(this, found.first);
  //   }
  // }
  //
  // @override
  // void onDragEnd(DragEndEvent event) {
  //   board.onDragEnd();
  // }
}
