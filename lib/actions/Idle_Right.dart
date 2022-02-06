import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame/game.dart';

class IdleRight extends SpriteAnimationComponent {
  Vector2 pos;

  IdleRight(this.pos);

  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad

    final spriteSize = Vector2(80.0, 67.0);

    final playerSpriteSheet = SpriteSheet(
      image: await Flame.images.load('adventurer-Sheet.png'),
      srcSize: Vector2(50, 37),
    );

    final IdleRight_01_PlayerAnim = playerSpriteSheet.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 4);

    final IdleRight_01_PlayerAnim_Comp = SpriteAnimationComponent(
      animation: IdleRight_01_PlayerAnim,
      position: Vector2(pos.x, pos.y),
      size: spriteSize,
    );

    add(IdleRight_01_PlayerAnim_Comp);

    return super.onLoad();
  }
}
