import 'package:flame/game/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/keyboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'components/hud.dart';
import 'components/world.dart';
import 'constants.dart';

class MyGame extends BaseGame with KeyboardEvents, DoubleTapDetector, PanDetector {

  double blockSize = DEFAULT_CELL_SIZE;

  MyGame() {
    add(Hud());
    add(World.empty(GRID_WIDTH, GRID_HEIGHT));
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
}
