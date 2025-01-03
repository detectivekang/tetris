import 'package:flutter/material.dart';

class Piece {
  Piece({required this.type}) {
    shape = tetrominos[type]!;
  }

  final int type;
  List<List<int>> shape = [];
  int x = 3;
  int y = 0;
  int rotation = 0;

  static const Map<int, Color> colors = {
    1: Colors.cyan, // I
    2: Colors.blue, // J
    3: Colors.orange, // L
    4: Colors.yellow, // O
    5: Colors.green, // S
    6: Colors.purple, // T
    7: Colors.red, // Z
  };

  static const Map<int, List<List<int>>> tetrominos = {
    1: [
      // I
      [1, 1, 1, 1],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
      [0, 0, 0, 0],
    ],
    2: [
      // J
      [1, 0, 0],
      [1, 1, 1],
      [0, 0, 0],
    ],
    3: [
      // L
      [0, 0, 1],
      [1, 1, 1],
      [0, 0, 0],
    ],
    4: [
      // O
      [1, 1],
      [1, 1],
    ],
    5: [
      // S
      [0, 1, 1],
      [1, 1, 0],
      [0, 0, 0],
    ],
    6: [
      // T
      [0, 1, 0],
      [1, 1, 1],
      [0, 0, 0],
    ],
    7: [
      // Z
      [1, 1, 0],
      [0, 1, 1],
      [0, 0, 0],
    ],
  };

  void rotate() {
    List<List<int>> newShape = List.generate(
      shape.length,
      (i) => List.generate(shape.length, (j) => shape[shape.length - 1 - j][i]),
    );
    shape = newShape;
    rotation = (rotation + 1) % 4;
  }

  bool isOccupying(int x, int y) {
    for (int i = 0; i < shape.length; i++) {
      for (int j = 0; j < shape[i].length; j++) {
        if (shape[i][j] == 1 && x == this.x + j && y == this.y + i) {
          return true;
        }
      }
    }
    return false;
  }
}
