import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_halo/actions/hud.dart';

enum PlayerState {
  idleRight,
  runningRight,
  dunkRight,
  attack_01_Right,
  idleLeft,
  runningLeft,
  dunkLeft,
  attack_01_Left,
}

class Halo extends FlameGame with KeyboardEvents, HasTappables {
  //main character
  static late SpriteAnimationGroupComponent player;

  // player velocity
  static const int speed = 200;
  static Vector2 velocity = Vector2(0, 0);

  //Joysticks

  @override
  Future<void>? onLoad() async {
    // Global player sprite sheet
    final playerSpriteSheet_Right = SpriteSheet(
      image: await images.load('adventurer-Sheet-right.png'),
      srcSize: Vector2(50, 37),
    );

    final playerSpriteSheet_Left = SpriteSheet(
      image: await images.load('adventurer-Sheet-left.png'),
      srcSize: Vector2(50, 37),
    );

    //Instances

    final spriteSize = Vector2(80.0, 67.0);

    // Animations

    //Right
    final runRight_PlayerAnim = playerSpriteSheet_Right.createAnimation(
        row: 1, stepTime: 0.1, from: 1, to: 5);

    final idleRight_PlayerAnim = playerSpriteSheet_Right.createAnimation(
        row: 0, stepTime: 0.1, from: 0, to: 4);

    final dunkRight_PlayerAnim = playerSpriteSheet_Right.createAnimation(
        row: 0, stepTime: 0.15, from: 5, to: 7);

    final attack_01_Right = playerSpriteSheet_Right.createAnimation(
        row: 6, stepTime: 0.1, from: 0, to: 4, loop: false);

    //Left
    final runLeft_PlayerAnim = playerSpriteSheet_Left.createAnimation(
        row: 1, stepTime: 0.1, from: 0, to: 5);

    final idleLeft_PlayerAnim = playerSpriteSheet_Left.createAnimation(
        row: 0, stepTime: 0.1, from: 3, to: 6);

    final dunkLeft_PlayerAnim = playerSpriteSheet_Left.createAnimation(
        row: 0, stepTime: 0.15, from: 0, to: 2);

    final attack_01_Left = playerSpriteSheet_Left.createAnimation(
        row: 6, stepTime: 0.1, from: 0, to: 4, loop: false);

    // Animation Groups

    player = SpriteAnimationGroupComponent<PlayerState>(
      animations: {
        PlayerState.runningRight: runRight_PlayerAnim,
        PlayerState.idleRight: idleRight_PlayerAnim,
        PlayerState.dunkRight: dunkRight_PlayerAnim,
        PlayerState.attack_01_Right: attack_01_Right,
        PlayerState.runningLeft: runLeft_PlayerAnim,
        PlayerState.idleLeft: idleLeft_PlayerAnim,
        PlayerState.dunkLeft: dunkLeft_PlayerAnim,
        PlayerState.attack_01_Left: attack_01_Left,
      },
      current: PlayerState.idleRight,
      // removeOnFinish: {
      //   PlayerState.attack_01_Left: true,
      //   PlayerState.attack_01_Right: true,
      //   PlayerState.idleLeft: false
      // },
      position: Vector2(size.x / 2, size.y / 2),
      size: spriteSize,
    );

    final arrowsSpriteSheet = SpriteSheet(
        image: await images.load('arrows.png'),
        srcSize: Vector2(32, 32)); //Arrows
    final attacksSpriteSheet = SpriteSheet(
        image: await images.load('attacks.png'),
        srcSize: Vector2(32, 32)); //Attacks

    final buttonSize = Vector2.all(60);

    final rightButtonSpriteComponent = SpriteComponent(
      sprite: arrowsSpriteSheet.getSpriteById(1),
      size: buttonSize,
    );

    final leftButtonSpriteComponent = SpriteComponent(
      sprite: arrowsSpriteSheet.getSpriteById(0),
      size: buttonSize,
    );

    final attack_01_ButtonSpriteComponent = SpriteComponent(
      sprite: attacksSpriteSheet.getSpriteById(0),
      size: buttonSize,
    );

    final rightButton = Huds(
        const EdgeInsets.only(
          left: 90,
          bottom: 80,
        ),
        Vector2(60, 60),
        rightButtonSpriteComponent,
        "Right");

    final leftButton = Huds(
        const EdgeInsets.only(
          left: 20,
          bottom: 80,
        ),
        Vector2(60, 60),
        leftButtonSpriteComponent,
        "Left");

    final attackButton_01 = Huds(
        const EdgeInsets.only(
          right: 20,
          bottom: 80,
        ),
        Vector2(60, 60),
        attack_01_ButtonSpriteComponent,
        "Attack_01");

    //Components
    add(leftButton);
    add(rightButton);
    add(attackButton_01);
    add(player);
    // add(leftButton);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    final displacement = velocity * (speed * dt);
    player.position.add(displacement);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      velocity.x = isKeyDown ? -1 : 0;

      isKeyDown
          ? player.current = PlayerState.runningLeft
          : player.current = PlayerState.idleLeft;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      velocity.x = isKeyDown ? 1 : 0;
      isKeyDown
          ? player.current = PlayerState.runningRight
          : player.current = PlayerState.idleRight;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      velocity.y = isKeyDown ? -1 : 0;

      if (isKeyDown) {
        if (player.current == PlayerState.dunkLeft ||
            player.current == PlayerState.idleLeft ||
            player.current == PlayerState.runningLeft) {
          player.current = PlayerState.idleLeft;
        } else if (player.current == PlayerState.dunkLeft ||
            player.current == PlayerState.idleLeft ||
            player.current == PlayerState.runningLeft) {
          player.current = PlayerState.idleRight;
        }
      } else {
        //TODO:
        // Nothing to do!
      }
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      velocity.y = isKeyDown ? 1 : 0;

      if (isKeyDown) {
        if (player.current == PlayerState.idleLeft) {
          player.current = PlayerState.dunkLeft;
        } else if (player.current == PlayerState.idleRight) {
          player.current = PlayerState.dunkRight;
        }
      } else {
        if (player.current == PlayerState.dunkLeft) {
          player.current = PlayerState.idleLeft;
        } else {
          player.current = PlayerState.idleRight;
        }
      }
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
