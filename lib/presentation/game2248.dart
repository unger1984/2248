import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:game2248/presentation/components/board.dart';

class Game2248 extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final world = World();

    camera = CameraComponent.withFixedResolution(width: 1080, height: 1920, world: world);
    // camera = CameraComponent(
    //     world: world,
    //     viewport: FixedAspectRatioViewport(aspectRatio: 1),
    //     viewfinder: Viewfinder()..anchor = Anchor.center);
    camera.viewport = FixedResolutionViewport(resolution: Vector2(1080, 1920));
    camera.viewfinder.position = Vector2.zero();
    camera.viewfinder.anchor = const Anchor(0, 0);
    camera.viewfinder.zoom = 1;
    world.add(Board());
    add(world);
  }
}
