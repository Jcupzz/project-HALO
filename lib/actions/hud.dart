import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:project_halo/Halo.dart';

class Huds extends HudButtonComponent {
  EdgeInsets margins;
  Vector2 sizes;
  SpriteComponent but;
  bool isLeft;
  Huds(this.margins, this.sizes, this.but, this.isLeft)
      : super(
          margin: margins,
          size: sizes,
          button: but,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    // TODO: implement onTapDown
    if (isLeft) {
      Halo.velocity.x = -1;
      Halo.player.current = PlayerState.runningLeft;
    } else {
      Halo.velocity.x = 1;
      Halo.player.current = PlayerState.runningRight;
    }
    return super.onTapDown(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    // TODO: implement onTapUp
    if (isLeft) {
      Halo.velocity.x = 0;
      Halo.player.current = PlayerState.idleLeft;
    } else {
      Halo.velocity.x = 0;
      Halo.player.current = PlayerState.idleRight;
    }
    print(info.toString());
    return super.onTapUp(info);
  }
}
