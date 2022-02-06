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
  String action;
  Huds(this.margins, this.sizes, this.but, this.action)
      : super(
          margin: margins,
          size: sizes,
          button: but,
        );

  @override
  bool onTapDown(TapDownInfo info) {
    // TODO: implement onTapDown
    if (action == "Left") {
      Halo.velocity.x = -1;
      Halo.player.current = PlayerState.runningLeft;
    } else if (action == "Right") {
      Halo.velocity.x = 1;
      Halo.player.current = PlayerState.runningRight;
    } else if (action == "Attack_01") {
      if (Halo.player.current == PlayerState.idleLeft) {
        Halo.player.current = PlayerState.attack_01_Left;
      } else if (Halo.player.current == PlayerState.idleRight) {
        Halo.player.current = PlayerState.attack_01_Right;
      }
    }
    return super.onTapDown(info);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    // TODO: implement onTapUp
    if (action == "Left") {
      Halo.velocity.x = 0;
      Halo.player.current = PlayerState.idleLeft;
    } else if (action == "Right") {
      Halo.velocity.x = 0;
      Halo.player.current = PlayerState.idleRight;
    }
    return super.onTapUp(info);
  }
}
