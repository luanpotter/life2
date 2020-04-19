import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../constants.dart';
import '../main.dart';
import '../matrix.dart';
import 'barrier.dart';
import 'cell.dart';
import 'empty.dart';
import 'food.dart';

class World extends Component with HasGameRef<MyGame> {

  static final emptyCell = Empty();
  static final foodCell = Food();
  static final barrierCell = Barrier();

  Matrix<Cell> cells;

  World.empty(int width, int height) {
    cells = Matrix.filled(width, height, emptyCell);
    List.generate(100, (index) => cells.setElement(R.nextInt(width), R.nextInt(height), R.nextBool() ? foodCell : barrierCell));
  }

  @override
  void render(Canvas c) {
    cells.forEach((i, j, cell) {
      c.save();
      c.translate(i * gameRef.blockSize, j * gameRef.blockSize);
      cell.render(c);
      c.restore();
    });
  }
  
  @override
  void update(double dt) {
    // TODO: implement update
  }
}