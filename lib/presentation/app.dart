import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game2248/presentation/game2248.dart';

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameWidget(game: Game2248()),
    );
  }
}
