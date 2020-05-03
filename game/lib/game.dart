import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'components/cells/cell.dart';
import 'components/cells/cell_type.dart';
import 'components/cells/food.dart';
import 'components/cells/life.dart';
import 'components/hud.dart';
import 'components/selected_cell.dart';
import 'components/ui/base_modal.dart';
import 'components/world.dart';
import 'constants.dart';

class MyGame extends BaseGame with HasWidgetsOverlay, KeyboardEvents, DoubleTapDetector, SecondaryTapDetector, PanDetector {

  Hud hud;
  World world;
  SelectedCell selectedCell;

  // automatically advacnes n ticks every second (0 == paused)
  int autoTickSpeed = 0;
  double clock = 0.0;

  double blockSize = DEFAULT_CELL_SIZE;

  MyGame() {
    add(hud = Hud());
    add(world = World.empty(GRID_WIDTH, GRID_HEIGHT));
    add(selectedCell = SelectedCell());
  }

  @override
  void update(double t) {
    super.update(t);
    if (autoTickSpeed != 0) {
      clock += t;
      if (clock > 1.0) {
        clock -= 1.0;
        world.tickN(autoTickSpeed);
      }
    }
  }

  void displayModal(String modal, void Function(Map<String, dynamic>) handler) {
    addWidgetOverlay('modal-$modal', BaseModal.create(
      modal,
      (Map<String, dynamic> data) {
        handler(data);
        removeWidgetOverlay('modal-$modal');
      },
      () {
        removeWidgetOverlay('modal-$modal');
      },
    ));
  }

  void resetWorld() {
    displayModal('NewWorldModal', (data) {
      world.doDestroy();
      add(world = World(data));
      clearSelector();
    });
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

  void setAutoTickSpeed(int speed) {
    this.autoTickSpeed = speed;
    this.clock = 0.0;
  }

  void tickN() {
    displayModal('TickNModal', (data) {
      int n = int.parse(data['n']);
      world.tickN(n);
    });
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
      if (hud.selectedToolRow == 0) {
        Cell newCell = hud.selectedTool.newCell();
        world.setCell(i, j, newCell);
        world.updateBoard();
      } else if (hud.selectedTool == CellType.FOOD) {
        displayModal('NewFoodModal', (data) {
            Cell newCell = Food.fromData(data);
            world.setCell(i, j, newCell);
            world.updateBoard();
        });
      } else if (hud.selectedTool == CellType.LIFE) {
        displayModal('NewLifeModal', (data) {
            Cell newCell = Life.fromData(data);
            world.setCell(i, j, newCell);
            world.updateBoard();
        });
      }
    }
  }
}
