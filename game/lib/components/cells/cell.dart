import 'dart:ui';

import 'cell_type.dart';

abstract class Cell {
  void render(Canvas c);
  CellType get type;
}