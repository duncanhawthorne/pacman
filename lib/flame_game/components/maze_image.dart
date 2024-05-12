import 'maze_walls.dart';
import '../helper.dart';

import '../endless_world.dart';
import '../constants.dart';
import 'package:flame/components.dart';

/// The [MiniPellet] components are the components that the [Player] should collect
/// to finish a level. The points are represented by Flame's mascot; Ember.
class MazeImage extends SpriteAnimationComponent
    with HasGameReference, HasWorldReference<EndlessWorld> {
  MazeImage() : super(size: spriteSize, anchor: Anchor.center);

  static final Vector2 spriteSize =
      Vector2.all(getSingleSquareWidth() * getMazeWidth());
  //final speed = 0;
  Vector2 absPosition = Vector2(0, 0);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.spriteList(
      [await game.loadSprite('dash/Pac-Man.png')],
      stepTime: double.infinity,
    );
    position = world.screenPos(absPosition);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (actuallyMoveSpritesToScreenPos) {
      position = world.screenPos(absPosition);
      angle = world.worldAngle;
    }
  }
}
