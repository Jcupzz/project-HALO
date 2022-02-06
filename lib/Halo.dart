import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum PlayerState {
  idleRight,
  runningRight,
  dunkRight,
  idleLeft,
  runningLeft,
  dunkLeft,
}

class Halo extends FlameGame with KeyboardEvents, HasDraggables {
  //main character
  late SpriteAnimationGroupComponent player;

  // player velocity
  static const int speed = 200;
  final Vector2 velocity = Vector2(0, 0);

  //Joystick
  late final JoystickComponent joystick;

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
    //Left
    final runLeft_PlayerAnim = playerSpriteSheet_Left.createAnimation(
        row: 1, stepTime: 0.1, from: 0, to: 5);

    final idleLeft_PlayerAnim = playerSpriteSheet_Left.createAnimation(
        row: 0, stepTime: 0.1, from: 3, to: 6);

    final dunkLeft_PlayerAnim = playerSpriteSheet_Left.createAnimation(
        row: 0, stepTime: 0.15, from: 0, to: 2);

    // Animation Groups

    player = SpriteAnimationGroupComponent<PlayerState>(
      animations: {
        PlayerState.runningRight: runRight_PlayerAnim,
        PlayerState.idleRight: idleRight_PlayerAnim,
        PlayerState.dunkRight: dunkRight_PlayerAnim,
        PlayerState.runningLeft: runLeft_PlayerAnim,
        PlayerState.idleLeft: idleLeft_PlayerAnim,
        PlayerState.dunkLeft: dunkLeft_PlayerAnim,
      },
      current: PlayerState.idleRight,
      position: Vector2(size.x / 2, size.y / 2),
      size: spriteSize,
    );

//Joystick
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    add(joystick);

    //Components
    add(player);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);

    final displacement = velocity * (speed * dt);
    player.position.add(displacement);

    print("vel : " + velocity.x.toString());

    final direction =
        joystick.direction.toString().replaceAll('JoystickDirection.', '');
    print(joystick.relativeDelta);
    if (!joystick.delta.isZero()) {
      switch (direction) {
        case "right":
          player.current = PlayerState.runningRight;
          break;
        case "left":
          player.current = PlayerState.runningLeft;
          break;
        case "idle":
          player.current = PlayerState.idleRight;
          break;
      }
    } else {
      if (player.current == PlayerState.dunkLeft ||
          player.current == PlayerState.idleLeft ||
          player.current == PlayerState.runningLeft) {
        player.current = PlayerState.idleLeft;
      } else if (player.current == PlayerState.dunkRight ||
          player.current == PlayerState.idleRight ||
          player.current == PlayerState.runningRight) {
        player.current = PlayerState.idleRight;
      }
    }
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
