import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../constants.dart';
import '../game.dart';
import '../palette.dart';
import 'cells/cell.dart';

class SelectedCell extends Component with HasGameRef<MyGame> {
  static final _paint = Palette.accent.paint ..style = PaintingStyle.stroke..strokeWidth = 2.0;
  static const size = DEFAULT_CELL_SIZE;

  int i, j;
  Cell cell;

  @override
  void render(Canvas c) {
    if (!isSelected()) {
      return;
    }

    final rect = Rect.fromLTWH(i * size, j * size, size, size);
    c.scale(gameRef.blockSize / DEFAULT_CELL_SIZE);
    staticRender(c, rect);
  }

  static void staticRender(Canvas c, Rect rect) {
    c.drawRect(rect, _paint);
  }

  bool isSelected() => i != null && j != null;
  
  @override
  void update(double dt) {}
}