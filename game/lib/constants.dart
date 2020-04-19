import 'dart:ui';
import 'dart:math' as math;

final R = math.Random();

const GRID_WIDTH = 100;
const GRID_HEIGHT = 100;
const DEFAULT_CELL_SIZE = 32.0;

final grid = Paint()..color = const Color(0xFF012136);
final food = Paint()..color = const Color(0xFF1C384F);
final barrier = Paint()..color = const Color(0xFF4F051B);
final white = Paint()..color = const Color(0xFFFFFFFF);
final life = Paint()..color = const Color(0xFFFADDA0);
final accent = Paint()..color = const Color(0xFFFB58BD3);