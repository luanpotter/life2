import '../world.dart';
import 'cell.dart';
import 'food.dart';
import 'life.dart';

enum CellType {
  EMPTY, BARRIER, FOOD, LIFE
}

extension MyCellType on CellType {
  Cell newCell() {
    switch(this) {
      case CellType.EMPTY: return World.emptyCell;
      case CellType.BARRIER: return World.barrierCell;
      case CellType.FOOD: return Food.random();
      case CellType.LIFE: return Life.defaultCell();
    }
    return null;
  }
}