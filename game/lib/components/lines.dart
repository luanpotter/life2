import 'dart:ui';

import 'package:flame/text_config.dart';
import 'package:flutter/painting.dart';

import '../palette.dart';

typedef Renderer = void Function(Canvas, double, double);
typedef Handler = void Function();

final _buttonBorder = Palette.accent.paint..strokeWidth = 2.0..style = PaintingStyle.stroke;

class _Line {
  double x;
  double y;
  double height;
  Renderer renderer;

  _Line(this.x, this.y, this.height, this.renderer);
}

class Lines {
  TextConfig textConfig;
  double x, y;
  double startY;
  double margin;

  List<_Line> _lines;

  Lines(this.textConfig, this.x, this.y, { this.margin = 8.0 }) {
    _lines = [];
    startY = y;
    y += margin;
  }

  double get end => _lines.last.y + _lines.last.height + margin;

  double baseX(Size size) => 0.8 * size.width + 8.0;

  void println(String text) {
    final tp = textConfig.toTextPainter(text);
    _lines.add(_Line(x, y, tp.height, (c, x, y) => tp.paint(c, Offset(x, y))));
    y += tp.height + margin;
  }

  void button(String text, Map<Rect, Handler> clicks, Handler handler) {
    final tp = textConfig.toTextPainter(text);
    _lines.add(_Line(x, y, tp.height, (c, x, y) {
      Rect rect = Rect.fromLTWH(x, y, tp.width + 4.0, tp.height + 4.0);
      c.drawRect(rect, _buttonBorder);
      tp.paint(c, Offset(x + 2.0, y + 2.0));
      clicks[rect] = handler;
    }));
    y += tp.height + margin;
  }

  void customRender(double height, Renderer renderer) {
    _lines.add(_Line(x, y, height, renderer));
    y += height + margin;
  }

  void render(Canvas c, Size size) {
    _renderBorder(c, size, startY, end - startY);
    _lines.forEach((line) {
      c.save();
      line.renderer(c, baseX(size) + line.x, line.y);
      c.restore();
    });
  }

  Rect _renderBorder(Canvas c, Size size, double y, double height) {
    final block = Rect.fromLTWH(baseX(size), y, 0.2 * size.width - 16.0, height);
    c.drawRect(block, Palette.accent.paint);
    c.drawRect(block.deflate(2.0), Palette.black.paint);
    return block;
  }

  Lines after(double gap) {
    return Lines(textConfig, x, end + gap, margin: margin);
  }
}