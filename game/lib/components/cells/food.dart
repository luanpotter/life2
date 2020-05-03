import 'dart:ui';

import '../../constants.dart';
import '../../palette.dart';
import 'cell.dart';
import 'cell_type.dart';

class Food extends Cell {
  static final paint1 = Palette.grid.paint;
  static final paint2 = Palette.black.paint;
  static final paint3 = Palette.grid.paint;
  static final paint4 = Palette.food.paint;

  static const size1 = const Rect.fromLTWH(0.0, 0.0, DEFAULT_CELL_SIZE, DEFAULT_CELL_SIZE);
  static final size2 = size1.deflate(2.0);
  static final size3 = size2.deflate(4.0);

  static const MAX_NUTRIENTS = 10.0;

  static final sampleFood = Food(0.0, 10.0, 10.0);

  double growthRate;
  double currentNutrients;
  double maxNutrients;

  Food(this.growthRate, this.currentNutrients, this.maxNutrients);

  Food.fromData(Map<String, dynamic> data) {
    this.maxNutrients = double.parse(data['maxNutrients']);
    this.growthRate = double.parse(data['growthRate']);
    this.currentNutrients = double.parse(data['currentNutrients']).clamp(0.0, this.maxNutrients);
  }

  Food.random() {
    this.growthRate = 0.5 * R.nextInt(4);
    this.currentNutrients = 0.0;
    this.maxNutrients = 10.0 - R.nextInt(4);
  }

  @override
  void render(Canvas c) {
    c.drawRect(size1, paint1);
    c.drawRect(size2, paint2);
    c.drawRect(size3, paint3);

    final maxSize = (DEFAULT_CELL_SIZE - 12.0) / 2;
    final deltaSize = (maxSize * (1 - currentNutrients / MAX_NUTRIENTS)).clamp(0.0, maxSize - 2.0);
    c.drawRect(size3.deflate(deltaSize), paint4);
  }

  void tick() {
    currentNutrients = (currentNutrients + growthRate).clamp(0.0, maxNutrients);
  }

  String describe() => "$currentNutrients / $maxNutrients nutrients [+ $growthRate nutrients/tick]";

  @override
  CellType get type => CellType.FOOD;
}