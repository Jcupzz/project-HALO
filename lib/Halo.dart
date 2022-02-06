import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:project_halo/actions/Idle_Right.dart';

class Halo extends FlameGame {
  @override
  Future<void>? onLoad() async {
    // TODO: implement onLoad

    print(size.x);
    print(size.x / 2);

    final idleRight = IdleRight(Vector2(size.x / 2, size.y / 2));

    add(idleRight);

    return super.onLoad();
  }
}
