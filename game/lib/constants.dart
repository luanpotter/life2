import 'dart:math' as math;

import 'package:flame/text_config.dart';

import 'palette.dart';

final R = math.Random();

const GRID_WIDTH = 20;
const GRID_HEIGHT = 20;
const DEFAULT_CELL_SIZE = 32.0;

final text = TextConfig(
  color: Palette.accent.color,
  fontSize: 16.0,
  fontFamily: 'Chonkly',
);