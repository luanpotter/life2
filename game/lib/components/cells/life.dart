import 'dart:ui';

import 'cell.dart';
import 'cell_type.dart';

class Life extends Cell {
  @override
  void render(Canvas c) {
    // TODO: implement render
  }

  @override
  CellType get type => CellType.LIFE;
}