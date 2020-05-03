import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'components/cells/cell.dart';
import 'components/cells/cell_type.dart';
import 'components/hud.dart';
import 'components/selected_cell.dart';
import 'components/ui/new_world_modal.dart';
import 'components/world.dart';
import 'constants.dart';

class MyGame extends BaseGame with HasWidgetsOverlay, KeyboardEvents, DoubleTapDetector, SecondaryTapDetector, PanDetector {

  Hud hud;
  World world;
  SelectedCell selectedCell;

  double blockSize = DEFAULT_CELL_SIZE;

  MyGame() {
    add(hud = Hud());
    add(world = World.empty(GRID_WIDTH, GRID_HEIGHT));
    add(selectedCell = SelectedCell());
  }

  void resetWorld() {
    addWidgetOverlay('NewWorldModal', NewWorldModal(
      createCallback: (Map<String, dynamic> data) {
        world.doDestroy();
        add(world = World(data));
        clearSelector();
        removeWidgetOverlay('NewWorldModal');
      },
      cancelCallback: () {
        removeWidgetOverlay('NewWorldModal');
      },
    ));
  }

  void resetCamera() {
    this.camera.x = 0.0;
    this.camera.y = 0.0;
    this.blockSize = DEFAULT_CELL_SIZE;
  }

  void clearSelector() {
    selectedCell.cell = null;
    selectedCell.i = null;
    selectedCell.j = null;
  }

  @override
  void onTapDown(TapDownDetails details) {
    if (hud.handleTap(details.localPosition)) {
      return;
    }

    int i = (details.localPosition.dx + camera.x) ~/ blockSize;
    int j = (details.localPosition.dy + camera.y) ~/ blockSize;
    
    Cell cell = world.getCell(i, j);
    if (cell == null) {
      clearSelector();
    } else {
      selectedCell.cell = cell;
      selectedCell.i = i;
      selectedCell.j = j;
    }
  }

  @override
  void onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      final key = event.data.keyLabel;

      if (key == "w") {
        camera.y += blockSize;
      } else if (key == "a") {
        camera.y += blockSize;
      } else if (key == "s") {
        camera.y -= blockSize;
      } else if (key == "d") {
        camera.y -= blockSize;
      } else if (key == "e") {
        blockSize *= 1.1;
      } else if (key == "q") {
        blockSize /= 1.1;
      }
    }
  }

  @override
  void onDoubleTap() {
    blockSize *= 2;
  }

  @override
  void onPanUpdate(DragUpdateDetails details) {
    camera.x -= details.delta.dx;
    camera.y -= details.delta.dy;
  }

  @override
  void onSecondaryTapDown(TapDownDetails details) {
    int i = (details.localPosition.dx + camera.x) ~/ blockSize;
    int j = (details.localPosition.dy + camera.y) ~/ blockSize;
    
    Cell cell = world.getCell(i, j);
    if (cell != null) {
      final newCell = hud.selectedTool.newCell();
      world.cells.setElement(i, j, newCell);
      world.updateBoard();
    }
  }
}
