import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../constants.dart';
import '../game.dart';
import '../palette.dart';
import 'cells/cell_type.dart';
import 'lines.dart';
import 'selected_cell.dart';
import 'world.dart';

class Hud extends Component with Resizable, HasGameRef<MyGame> {
  CellType selectedTool = CellType.EMPTY;
  Map<Rect, void Function()> clicks = {};

  @override
  void render(Canvas c) {
    clicks = {};

    final hudArea = Rect.fromLTWH(0.8 * size.width, 0.0, 0.2 * size.width, size.height);
    c.drawRect(hudArea, Palette.accent.paint);
    c.drawRect(hudArea.deflate(4.0), Palette.black.paint);

    final selectedBlock = Lines(text, 8.0, 8.0);
    selectedBlock.println('Selected Block (Left Click)');
    final cell = gameRef.selectedCell;
    if (cell.isSelected()) {
      selectedBlock.println('Cell [${cell.i}, ${cell.j}]: ${cell.cell.type}');
    }
    selectedBlock.render(c, size);

    final toolsBlock = selectedBlock.after(4.0);
    toolsBlock.println('Tools (Right Click)');
    const s = DEFAULT_CELL_SIZE;
    const selector = const Rect.fromLTWH(0.0, 0.0, s, s);
    final m = 8.0 + DEFAULT_CELL_SIZE;
    toolsBlock.customRender(m, (c, x, y) {
      c.translate(x, y);
      World.emptyCell.render(c);
      if (selectedTool == CellType.EMPTY) {
        SelectedCell.staticRender(c, selector);
      } else {
        clicks[Rect.fromLTWH(x, y, s, s)] = () => selectedTool = CellType.EMPTY;
      }
      c.translate(m, 0.0);
      World.barrierCell.render(c);
      if (selectedTool == CellType.BARRIER) {
        SelectedCell.staticRender(c, selector);
      } else {
        clicks[Rect.fromLTWH(x + m, y, s, s)] = () => selectedTool = CellType.BARRIER;
      }
      c.translate(m, 0.0);
      World.foodCell.render(c);
      if (selectedTool == CellType.FOOD) {
        SelectedCell.staticRender(c, selector);
      } else {
        clicks[Rect.fromLTWH(x + 2 * m, y, s, s)] = () => selectedTool = CellType.FOOD;
      }
    });
    
    toolsBlock.render(c, size);
  }

  @override
  void update(double dt) {}

  bool handleTap(Offset offset) {
    final click = clicks.entries.firstWhere((element) => element.key.contains(offset), orElse: () => null);
    if (click != null) {

      click.value();
      return true;
    }
    return false;
  }

  @override
  int priority() => 2;

  @override
  bool isHud() => true;
}
