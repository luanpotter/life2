import 'dart:ui';

import '../../constants.dart';
import '../../palette.dart';
import 'cell.dart';
import 'cell_type.dart';

class Life extends Cell {

  static const MAX_SIZE = 10.0;
  static const MAX_RADIUS = (DEFAULT_CELL_SIZE - 8.0) / 2;
  static const center = Offset(DEFAULT_CELL_SIZE / 2, DEFAULT_CELL_SIZE / 2);

  static final paint1 = Palette.grid.paint;
  static final paint2 = Palette.black.paint;
  static final paint3 = Palette.grid.paint;
  static final paint4 = Palette.life.paint;

  static const size1 = const Rect.fromLTWH(0.0, 0.0, DEFAULT_CELL_SIZE, DEFAULT_CELL_SIZE);
  static final size2 = size1.deflate(2.0);
  static final size3 = size2.deflate(4.0);

  static final sampleLife = Life.defaultCell();

  double size;

  Life.defaultCell() : size = 5.0;

  Life.fromData(Map<String, dynamic> data) {
    size = double.parse(data['size']);
  }

  @override
  void render(Canvas c) {
    c.drawRect(size1, paint1);
    c.drawRect(size2, paint2);
    c.drawRect(size3, paint3);

    final radius = 1.0 + (MAX_RADIUS - 1.0) * (size / MAX_SIZE);
    c.drawCircle(center, radius, paint4);
  }

  void tick() {
    // TODO: implement tick properly
    if (R.nextDouble() > 0.5) {
      List<List<int>> dirs = [[0, 1], [0, -1], [1, 0], [-1, 0]];
      int dir = R.nextInt(4);
      world.moveCell(i, j, dirs[dir][0], dirs[dir][1]);
    }
  }

  String describe() => "A simple life. TODO";

  @override
  CellType get type => CellType.LIFE;
}