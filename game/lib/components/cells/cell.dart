import 'dart:ui';

abstract class Cell {
  void render(Canvas c);
  String get type;
}