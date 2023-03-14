import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:game2248/presentation/blocs/sound_bloc.dart';
import 'package:game2248/presentation/components/main/board_component.dart';

class Game2248 extends FlameGame with HasTappableComponents, HasDraggableComponents {
  final SoundBLoC soundBLoC;
  late final FlameBlocProvider<SoundBLoC, SoundState> blocProvider;

  Game2248({required this.soundBLoC});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    camera.zoom = 1;
    camera.viewport = DefaultViewport();

    blocProvider = FlameBlocProvider<SoundBLoC, SoundState>.value(value: soundBLoC);

    await add(blocProvider);

    await blocProvider.add(BoardComponent());
  }
}
