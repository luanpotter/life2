import 'dart:ui';

import '../../constants.dart';
import '../../palette.dart';
import 'cell.dart';

class Food extends Cell {
  static final paint1 = Palette.grid.paint;
  static final paint2 = Palette.black.paint;
  static final paint3 = Palette.food.paint;

  static const size1 = const Rect.fromLTWH(0.0, 0.0, DEFAULT_CELL_SIZE, DEFAULT_CELL_SIZE);
  static final size2 = size1.deflate(2.0);
  static final size3 = size2.deflate(4.0);

  @override
  void render(Canvas c) {
    c.drawRect(size1, paint1);
    c.drawRect(size2, paint2);
    c.drawRect(size3, paint3);
  }
}