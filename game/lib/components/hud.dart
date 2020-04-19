import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';

import '../palette.dart';

class Hud extends Component with Resizable {
  @override
  void render(Canvas c) {
    c.drawRect(Rect.fromLTWH(0.8 * size.width, 0.0, 0.2 * size.width, size.height), Palette.accent.paint);
  }

  @override
  void update(double dt) {
  }

  @override
  int priority() => 2;

  @override
  bool isHud() => true;
}
