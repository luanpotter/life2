import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';

import '../constants.dart';
import '../game.dart';
import '../matrix.dart';
import '../palette.dart';
import 'cells/barrier.dart';
import 'cells/cell.dart';
import 'cells/empty.dart';
import 'cells/food.dart';

class World extends Component with HasGameRef<MyGame> {

  static final _paint = Palette.white.paint..filterQuality = FilterQuality.high;

  static final emptyCell = Empty();
  static final barrierCell = Barrier();

  Matrix<Cell> cells;
  Image _cache;

  bool _destroy = false;

  World.empty(int width, int height) {
    cells = Matrix.filled(width, height, emptyCell);
    List.generate(100, (index) => cells.setElement(R.nextInt(width), R.nextInt(height), R.nextBool() ? Food.random() : barrierCell));
    updateBoard();
  }

  Cell getCell(int i, int j) {
    return cells.getElementOrNull(i, j);
  }

  Future<Image> _redrawCache() {
    final w = cells.width * DEFAULT_CELL_SIZE;
    final h = cells.height * DEFAULT_CELL_SIZE;
    final PictureRecorder recorder = PictureRecorder();
    final Canvas c = Canvas(recorder, Rect.fromLTWH(0.0, 0.0, w, h));
    _fullRender(c);
    return recorder.endRecording().toImage(w.toInt(), h.toInt());
  }

  void _fullRender(Canvas c) {
    cells.forEach((i, j, cell) {
      c.save();
      c.translate(i * DEFAULT_CELL_SIZE, j * DEFAULT_CELL_SIZE);
      cell.render(c);
      c.restore();
    });
  }

  void updateBoard() async {
    _cache = await _redrawCache();
  }

  @override
  void render(Canvas c) {
    if (_cache == null) {
      return;
    }
    c.scale(gameRef.blockSize / DEFAULT_CELL_SIZE);
    c.drawImage(_cache, const Offset(0, 0), _paint);
  }
  
  @override
  void update(double dt) {
    // TODO: implement update
  }

  @override
  bool destroy() => _destroy;

  void doDestroy() {
    _destroy = true;
  }

  @override
  int priority() => 0;
}