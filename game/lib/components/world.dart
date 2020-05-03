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
import 'ui/new_world_modal.dart';

class World extends Component with HasGameRef<MyGame> {

  static final _paint = Palette.white.paint..filterQuality = FilterQuality.high;

  static final emptyCell = Empty();
  static final barrierCell = Barrier();

  Matrix<Cell> cells;
  Image _cache;

  bool _destroy = false;

  World.empty(int width, int height) {
    cells = Matrix.filled(width, height, emptyCell);
    List.generate(100, (index) => setCell(R.nextInt(width), R.nextInt(height), R.nextBool() ? Food.random() : barrierCell));
    updateBoard();
  }

  World(Map<String, dynamic> data) {
    int width = int.parse(data['width']);
    int height = int.parse(data['height']);
    NewWorldType type = data['worldType'];
    int randomFood = int.parse(data['randomFood']);
    int randomBarrier = int.parse(data['randomBarrier']);
    cells = Matrix.filled(width, height, emptyCell);
    if (type == NewWorldType.BORDERED) {
      for (int i = 0; i < width; i++) {
        setCell(i, 0, barrierCell);
        setCell(i, height - 1, barrierCell);
      }
      for (int i = 0; i < height; i++) {
        setCell(0, i, barrierCell);
        setCell(width - 1, i, barrierCell);
      }
    }
    List.generate(randomFood, (index) => setCell(R.nextInt(width - 2) + 1, R.nextInt(height - 2) + 1, Food.random()));
    List.generate(randomBarrier, (index) => setCell(R.nextInt(width - 2) + 1, R.nextInt(height - 2) + 1, barrierCell));
    updateBoard();
  }

  Cell getCell(int i, int j) {
    return cells.getElementOrNull(i, j);
  }

  void setCell(int i, int j, Cell cell) {
    cell.world = this;
    cell.i = i;
    cell.j = j;
    cells.setElement(i, j, cell);
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

  void tickOnce() {
    _tick();
    updateBoard();
  }

  void tickN(int n) {
    for (var i = 0; i < n; i++) {
      _tick();
    }
    updateBoard();
  }

  void _tick() {
    cells.forEach((i, j, cell) => cell.tick());
  }

  void moveCell(int i, int j, int dx, int dy) {
    Cell cell = this.getCell(i, j);
    Cell dest = this.getCell(i + dx, j + dy);
    if (dest != emptyCell) {
      return;
    }

    setCell(i + dx, j + dy, cell);
    setCell(i, j, emptyCell);
  }

  @override
  int priority() => 0;
}