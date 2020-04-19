import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/position.dart';

import '../constants.dart';
import '../palette.dart';

class Hud extends Component with Resizable {
  @override
  void render(Canvas c) {
    final hudArea = Rect.fromLTWH(0.8 * size.width, 0.0, 0.2 * size.width, size.height);
    c.drawRect(hudArea, Palette.accent.paint);
    c.drawRect(hudArea.deflate(4.0), Palette.black.paint);

    final selectedBlock = Rect.fromLTWH(0.8 * size.width + 8.0, 8.0, 0.2 * size.width - 16.0, 200.0);
    c.drawRect(selectedBlock, Palette.accent.paint);
    c.drawRect(selectedBlock.deflate(2.0), Palette.black.paint);

    text.render(c, 'Selected Block', Position.fromOffset(selectedBlock.topLeft).add(Position(4.0, 4.0)));
  }

  @override
  void update(double dt) {
  }

  @override
  int priority() => 2;

  @override
  bool isHud() => true;
}
