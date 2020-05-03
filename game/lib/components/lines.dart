import 'dart:ui';
import 'dart:math' as math;

import 'package:flame/text_config.dart';
import 'package:flutter/painting.dart';

import '../palette.dart';

typedef Renderer = void Function(Canvas, double, double);
typedef Handler = void Function();

final _buttonBorder = Palette.accent.paint..strokeWidth = 2.0..style = PaintingStyle.stroke;
final _selectedButtonBorder = Palette.life.paint..strokeWidth = 2.0..style = PaintingStyle.stroke;

class _Line {
  double x;
  double y;
  double height;
  Renderer renderer;

  _Line(this.x, this.y, this.height, this.renderer);
}

class _Button {
  String text;
  Handler handler;
  TextPainter tp;
  bool selected;

  _Button(TextConfig textConfig, this.text, this.handler, this.selected) {
    tp = textConfig.toTextPainter(text);
  }
}

class Line {
  TextConfig textConfig;
  List<_Button> buttons = [];

  Line(this.textConfig);

  void button(String text, Handler handler, { bool selected = false }) {
    buttons.add(_Button(textConfig, text, handler, selected));
  }
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

  void customLine(Map<Rect, Handler> clicks, void Function(Line) builder) {
    Line line = Line(textConfig);
    builder(line);

    final height = line.buttons.map((e) => e.tp.height).reduce(math.max);
    _lines.add(_Line(x, y, height, (c, x, y) {
      double currentX = x;
      line.buttons.forEach((btn) {
        Rect rect = Rect.fromLTWH(currentX, y, btn.tp.width + 4.0, btn.tp.height + 4.0);
        Paint border = btn.selected ? _selectedButtonBorder : _buttonBorder;
        c.drawRect(rect, border);
        btn.tp.paint(c, Offset(currentX + 2.0, y + 2.0));
        clicks[rect] = btn.handler;
        currentX += btn.tp.width + margin;
      });
    }));
    y += height + margin;
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