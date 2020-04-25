import 'dart:ui';

import 'cell_type.dart';

abstract class Cell {
  void render(Canvas c);
  void tick();
  CellType get type;
}