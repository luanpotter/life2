import 'package:flutter/material.dart';

import 'game.dart';

void main() {
  final game = MyGame();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => game.widget,
      },
    ),
  );
}
