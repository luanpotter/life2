import 'dart:ui';

import '../world.dart';
import 'cell_type.dart';

abstract class Cell {
  World world;
  int i, j;
  CellType get type;

  void render(Canvas c);
  void tick();
  String describe();
}