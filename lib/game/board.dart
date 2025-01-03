import 'piece.dart';

class Board {
  static const int rows = 20;
  static const int columns = 10;
  
  List<List<int>> board = List.generate(
    rows,
    (i) => List.generate(columns, (j) => 0),
  );

  bool isValidMove(Piece piece, int newX, int newY) {
    for (int i = 0; i < piece.shape.length; i++) {
      for (int j = 0; j < piece.shape[i].length; j++) {
        if (piece.shape[i][j] == 1) {
          int finalX = newX + j;
          int finalY = newY + i;
          
          if (finalX < 0 || finalX >= columns || finalY >= rows) return false;
          if (finalY >= 0 && board[finalY][finalX] != 0) return false;
        }
      }
    }
    return true;
  }

  void placePiece(Piece piece) {
    for (int i = 0; i < piece.shape.length; i++) {
      for (int j = 0; j < piece.shape[i].length; j++) {
        if (piece.shape[i][j] == 1) {
          if (piece.y + i >= 0) {
            board[piece.y + i][piece.x + j] = piece.type;
          }
        }
      }
    }
  }

  int clearLines() {
    int linesCleared = 0;
    for (int i = rows - 1; i >= 0; i--) {
      if (board[i].every((cell) => cell != 0)) {
        board.removeAt(i);
        board.insert(0, List.generate(columns, (j) => 0));
        linesCleared++;
        i++; // 한 줄이 제거되면 같은 위치를 다시 검사
      }
    }
    return linesCleared;
  }
} 