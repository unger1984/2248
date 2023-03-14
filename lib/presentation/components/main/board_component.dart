import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:game2248/domain/entities/line_entity.dart';
import 'package:game2248/presentation/components/main/gem.dart';
import 'package:game2248/presentation/components/main/line.dart';
import 'package:game2248/presentation/game_2248.dart';
import 'package:game2248/utils/const.dart';

class BoardComponent extends PositionComponent with HasGameRef<Game2248>, DragCallbacks {
  final _random = Random();
  static final boardSize = Vector2(5, 8);
  final _board = <Vector2, Gem?>{};
  final _back = <Vector2, PositionComponent?>{};
  bool allowClick = false;
  final _line = Line();
  final _toClean = <GemNum>[];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // debugMode = true;

    size = Vector2(boardSize.x * (Gem.gemSize.x + 20), boardSize.y * (Gem.gemSize.y + 20));
    position = Vector2(gameRef.size.x / 2 - scaledSize.x / 2, gameRef.size.y / 2 - scaledSize.y / 2);

    await add(_line);

    await _fillEmpty();
    _spawnNewGems();

    // Future.delayed(Duration(seconds: 2), () {
    //   _line.points = [
    //     Vector2(10, 10),
    //     Vector2(100, 40),
    //     Vector2(100, 100),
    //   ];
    //   Future.delayed(Duration(seconds: 2), () {
    //     _line.points = [
    //       Vector2(100, 100),
    //       Vector2(200, 40),
    //       Vector2(400, 100),
    //     ];
    //   });
    // });
  }

  Vector2 coordinate(Vector2 pos) {
    final current = _back[pos];
    if (current != null) {
      return current.position;
    }

    return Vector2.zero();
  }

  Future<void> _fillEmpty() async {
    removeAll(children);
    _board.clear();
    for (double col = 0; col < boardSize.x; col++) {
      for (double row = 0; row < boardSize.y; row++) {
        final pos = Vector2(col, row);
        final bg = PositionComponent(size: Gem.gemSize, anchor: Anchor.center);
        _back[pos] = bg;
        await add(bg);
        bg.position = Vector2(col * (Gem.gemSize.x + 25), row * (Gem.gemSize.y + 22)) + bg.size / 2;
        _spawnGem(GemEmpty(), pos);
        // final gem = GemEmpty();
        // _board[pos] = gem;
        // gem.
      }
    }
  }

  Future<void> _spawnGem(Gem gem, Vector2 pos) async {
    _board[pos] = gem;
    gem.pos = pos;
    gem.position = coordinate(pos);
    await add(gem);
  }

  Future<void> _moveGem(GemNum gem, Vector2 pos, {double speed = moveSpeed}) async {
    await gem.move(coordinate(pos), speed: speed);
    gem.pos = pos;
    _board[pos] = gem;
  }

  Future<bool> _fillStep(bool inverse) async {
    bool hasMoved = false;
    for (double row = boardSize.y - 2; row >= 0; row--) {
      final futures = <Future<void>>[];
      for (double loopX = 0; loopX < boardSize.x; loopX++) {
        var col = inverse ? boardSize.x - 1 - loopX : loopX;

        final gem = _board[Vector2(col, row)];
        if (gem != null && gem is GemNum) {
          final gemDown = _board[Vector2(col, row + 1)];
          final back = _back[Vector2(col, row + 1)];
          if (back != null && gemDown != null && gemDown is GemEmpty) {
            // Если гем под ним пустой
            remove(gemDown);
            futures.add(_moveGem(gem, Vector2(col, row + 1), speed: spawnSpeed));
            futures.add(_spawnGem(GemEmpty(), Vector2(col, row)));
            hasMoved = true;
          }
        }
      }
      await Future.wait(futures);
    }

    // Верхний ряд
    for (double col = 0; col < boardSize.x; col++) {
      final gemBelow = _board[Vector2(col, 0)];
      if (gemBelow != null && gemBelow is GemEmpty) {
        remove(gemBelow);
        await _spawnGem(_getGem(), Vector2(col, 0));
        hasMoved = true;
      }
    }

    return hasMoved;
  }

  Future<void> _spawnNewGems() async {
    allowClick = false;
    bool needRefill = true;
    while (needRefill) {
      bool inverse = false;
      bool hasMoved = true;
      while (hasMoved) {
        hasMoved = await _fillStep(inverse);
        inverse = !inverse;
      }
      needRefill = false;
      // var count = await _clearAllValidMatches();
      // needRefill = count > 0;
    }
    // if (!isEndLevel) {
    //   if (screen.targets.complete) {
    //     screen.showResult(true);
    //   } else {
    allowClick = true;
    //   }
    // } else {
    //   screen.showResult(screen.targets.complete);
    // }
  }

  Gem _getGem() {
    final cfg = allGems.elementAt(_random.nextInt(allGems.length));

    return GemNum(config: cfg);
  }

  // Future<void> onDragGem(GemNum first, GemNum next) async {
  //   if (!_toClean.contains(first)) _toClean.add(first);
  //   if (!_toClean.contains(next)) {
  //     if (_isAdjacent(_toClean.last.pos, next.pos)) {
  //       if (_isSumm(_toClean.last, next)) _toClean.add(next);
  //     }
  //   } else if (_toClean.length > 1) {
  //     final prev = _toClean.elementAt(_toClean.length - 2);
  //     if (prev.pos.x == next.pos.x && prev.pos.y == next.pos.y) {
  //       _toClean.remove(_toClean.last);
  //     }
  //   }
  //   _line.points = _toClean.map((item) => coordinate(item.pos)).toList();
  // }

  bool _isAdjacent(Vector2 first, Vector2 next) {
    final dx = (first.x - next.x).abs().toInt();
    final dy = (first.y - next.y).abs().toInt();

    return ((first.x == next.x && dy == 1) || (first.y == next.y && dx == 1) || (dy == 1 && dx == 1));
  }

  bool _isSumm(GemNum first, GemNum next) {
    return first.config.num == next.config.num
        ? true
        : _toClean.length > 1 &&
            (allGems.indexWhere((itm) => itm.num == next.config.num) -
                    allGems.indexWhere((itm) => itm.num == first.config.num) ==
                1);
  }

  @override
  void onDragStart(DragStartEvent event) {
    final found = gameRef.componentsAtPoint(event.devicePosition).whereType<GemNum>().toList();
    _toClean.clear();
    if (found.isNotEmpty) _toClean.add(found.first);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final found = gameRef.componentsAtPoint(event.devicePosition).whereType<GemNum>().toList();
    if (found.isNotEmpty) {
      final next = found.first;
      if (!_toClean.contains(next)) {
        if (next != _toClean.last) {
          if (_isAdjacent(_toClean.last.pos, next.pos)) {
            if (_isSumm(_toClean.last, next)) {
              _toClean.add(next);
            }
          }
          // }
        }
      } else if (_toClean.length > 1) {
        final prev = _toClean.elementAt(_toClean.length - 2);
        if (prev.pos.x == next.pos.x && prev.pos.y == next.pos.y) {
          _toClean.remove(_toClean.last);
        }
      }
    }
    final points = <LineEntity>[];

    for (var index = 0; index < _toClean.length; index++) {
      final gem = _toClean.elementAt(index);
      var end = event.localPosition;
      if (index != _toClean.length - 1) {
        end = coordinate(_toClean.elementAt(index + 1).pos);
      }
      points.add(LineEntity(color: gem.config.color, start: coordinate(gem.pos), end: end));
    }
    _line.points = points;
  }

  @override
  Future<void> onDragEnd(DragEndEvent event) async {
    if (_toClean.length > 1) {
      var lastPos = _toClean.last.pos.clone();
      final indexes = <int>[];
      for (var gem in _toClean) {
        final pos = gem.pos.clone();
        final index = allGems.indexWhere((cfg) => cfg == gem.config);
        indexes.add(index);
        remove(gem);
        await _spawnGem(GemEmpty(), pos);
      }
      final unique = indexes.toSet().toList();
      var sumindex = 0;
      for (var index in unique) {
        sumindex += indexes.where((itm) => itm == index).length ~/ 2;
      }
      var newIndex = indexes.last + sumindex;
      if (newIndex > allGems.length - 1) newIndex = allGems.length - 1;
      final cfg = allGems.elementAt(newIndex);
      await _spawnGem(GemNum(config: cfg), lastPos);
      _spawnNewGems();
    }
    _toClean.clear();
    _line.points = [];
  }

  @override
  void onGameResize(Vector2 size) {
    scale = Vector2.all(size.x / maxWidth);
    position = Vector2(size.x / 2 - scaledSize.x / 2, size.y / 2 - scaledSize.y / 2);
    super.onGameResize(size);
  }
}
