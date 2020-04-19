import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/world.dart';
import 'constants.dart';

void main() {
  final game = MyGame();
  runApp(game.widget);
}

class MyGame extends BaseGame {

  double get blockSize => DEFAULT_CELL_SIZE;

  MyGame() {
    add(World.empty(GRID_WIDTH, GRID_HEIGHT));
  }
}
