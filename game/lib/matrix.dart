class Matrix<T> {
  List<List<T>> data;

  Matrix.filled(int width, int height, T t) : this(width, height, (i, j) => t);

  Matrix(int width, int height, T Function(int, int) generator) {
    data = List.generate(width, (i) => List.generate(height, (j) => generator(i, j)));
  }

  T getElement(int i, int j) {
    return data[i][j];
  }

  void setElement(int i, int j, T t) {
    data[i][j] = t;
  }

  void forEach(void Function(int, int, T) consumer) {
    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        consumer(i, j, data[i][j]);
      }
    }
  }
}