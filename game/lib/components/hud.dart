import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../constants.dart';
import '../game.dart';
import '../palette.dart';
import 'cells/cell_type.dart';
import 'cells/food.dart';
import 'cells/life.dart';
import 'lines.dart';
import 'selected_cell.dart';
import 'world.dart';

class Hud extends Component with Resizable, HasGameRef<MyGame> {
  CellType selectedTool = CellType.EMPTY;
  int selectedToolRow = 0;
  Map<Rect, Handler> clicks = {};

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
      selectedBlock.println(cell.cell.describe());
    }
    selectedBlock.render(c, size);

    final toolsBlock = selectedBlock.after(4.0);
    toolsBlock.println('Tools (Right Click)');
    toolsBlock.println('Default');
    const s = DEFAULT_CELL_SIZE;
    const selector = const Rect.fromLTWH(0.0, 0.0, s, s);
    final m = 8.0 + DEFAULT_CELL_SIZE;
    void addClick(double x, double y, int row, CellType tool) {
      clicks[Rect.fromLTWH(x, y, s, s)] = () {
        selectedToolRow = row;
        selectedTool = tool;
      };
    }
    toolsBlock.customRender(m, (c, x, y) {
      c.translate(x, y);
      World.emptyCell.render(c);
      if (selectedToolRow == 0 && selectedTool == CellType.EMPTY) {
        SelectedCell.staticRender(c, selector);
      } else {
        addClick(x, y, 0, CellType.EMPTY);
      }
      c.translate(m, 0.0);
      World.barrierCell.render(c);
      if (selectedToolRow == 0 && selectedTool == CellType.BARRIER) {
        SelectedCell.staticRender(c, selector);
      } else {
        addClick(x + m, y, 0, CellType.BARRIER);
      }
      c.translate(m, 0.0);
      Food.sampleFood.render(c);
      if (selectedToolRow == 0 && selectedTool == CellType.FOOD) {
        SelectedCell.staticRender(c, selector);
      } else {
        addClick(x + 2 * m, y, 0, CellType.FOOD);
      }
      c.translate(m, 0.0);
      Life.sampleLife.render(c);
      if (selectedToolRow == 0 && selectedTool == CellType.LIFE) {
        SelectedCell.staticRender(c, selector);
      } else {
        addClick(x + 3 * m, y, 0, CellType.LIFE);
      }
    });
    toolsBlock.println('Custom');
    toolsBlock.customRender(m, (c, x, y) {
      c.translate(x + 2 * m, y);
      Food.sampleFood.render(c);
      if (selectedToolRow == 1 && selectedTool == CellType.FOOD) {
        SelectedCell.staticRender(c, selector);
      } else {
        addClick(x + 2 * m, y, 1, CellType.FOOD);
      }
      c.translate(m, 0.0);
      Life.sampleLife.render(c);
      if (selectedToolRow == 1 && selectedTool == CellType.LIFE) {
        SelectedCell.staticRender(c, selector);
      } else {
        addClick(x + 3 * m, y, 1, CellType.LIFE);
      }
    });
    toolsBlock.render(c, size);

    final simulationBlock = toolsBlock.after(4.0);
    simulationBlock.println('Simulation');
    simulationBlock.customLine(clicks, (lines) {
      lines.button('Pause', () => gameRef.setAutoTickSpeed(0), selected: gameRef.autoTickSpeed == 0);
      lines.button('1x', () => gameRef.setAutoTickSpeed(1), selected: gameRef.autoTickSpeed == 1);
      lines.button('2x', () => gameRef.setAutoTickSpeed(2), selected: gameRef.autoTickSpeed == 2);
      lines.button('10x', () => gameRef.setAutoTickSpeed(10), selected: gameRef.autoTickSpeed == 10);
    });
    simulationBlock.customLine(clicks, (lines) {
      lines.button('Tick Once', () => gameRef.world.tickOnce());
      lines.button('Tick 10', () => gameRef.world.tickN(10));
      lines.button('Tick n', () => gameRef.tickN());
    });
    simulationBlock.render(c, size);

    final optionsBlock = simulationBlock.after(4.0);
    optionsBlock.println('Options');
    optionsBlock.button('New World', clicks, () => gameRef.resetWorld());
    optionsBlock.button('Reset Camera', clicks, () => gameRef.resetCamera());
    optionsBlock.render(c, size);
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
