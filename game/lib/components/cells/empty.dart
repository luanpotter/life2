import 'dart:ui';

import 'package:life2/constants.dart';

import '../../palette.dart';
import 'cell.dart';
import 'cell_type.dart';

class Empty extends Cell {
  static final paint1 = Palette.grid.paint;
  static final paint2 = Palette.black.paint;

  static const size1 = const Rect.fromLTWH(0.0, 0.0, DEFAULT_CELL_SIZE, DEFAULT_CELL_SIZE);
  static final size2 = size1.deflate(2.0);
  static final size3 = size2.deflate(4.0);

  @override
  void render(Canvas c) {
    c.drawRect(size1, paint1);
    c.drawRect(size2, paint2);
    c.drawRect(size3, paint1);
  }

  void tick() {}

  @override
  CellType get type => CellType.EMPTY;
}