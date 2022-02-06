import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:project_halo/Halo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final game = Halo();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: game,
      backgroundBuilder: (context) {
        return Container(
          color: Colors.grey[900],
        );
      },
    );
  }
}
