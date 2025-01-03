import 'dart:async';
import 'dart:math';
import 'board.dart';
import 'piece.dart';

class TetrisGame {
  Board board;
  Piece? currentPiece;
  Piece? nextPiece;
  bool isGameOver = false;
  bool isPaused = false;
  int score = 0;
  int level = 1;
  int lines = 0;
  Timer? gameTimer;
  final Function setState;
  int combo = 0;
  String? comboMessage;
  Timer? comboTimer;
  Piece? holdPiece;
  bool canHold = true;

  TetrisGame({required this.setState}) : board = Board();

  void startGame() {
    isGameOver = false;
    isPaused = false;
    score = 0;
    level = 1;
    lines = 0;
    board = Board();
    spawnNewPiece();
    startTimer();
  }

  void startTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(
      Duration(milliseconds: (800 * pow(0.85, level - 1)).toInt()),
      (timer) {
        if (!isPaused && !isGameOver) {
          moveDown();
        }
      },
    );
  }

  void spawnNewPiece() {
    currentPiece = nextPiece ?? Piece(type: Random().nextInt(7) + 1);
    nextPiece = Piece(type: Random().nextInt(7) + 1);

    if (!board.isValidMove(currentPiece!, currentPiece!.x, currentPiece!.y)) {
      gameOver();
    }
    canHold = true;
    setState(() {});
  }

  void gameOver() {
    isGameOver = true;
    gameTimer?.cancel();
    setState(() {});
  }

  void togglePause() {
    isPaused = !isPaused;
    setState(() {});
  }

  void moveDown() {
    if (currentPiece == null) return;

    if (board.isValidMove(
        currentPiece!, currentPiece!.x, currentPiece!.y + 1)) {
      setState(() {
        currentPiece!.y++;
      });
    } else {
      board.placePiece(currentPiece!);
      int clearedLines = board.clearLines();
      updateScore(clearedLines);
      spawnNewPiece();
    }
  }

  void hardDrop() {
    if (currentPiece == null) return;

    while (board.isValidMove(
        currentPiece!, currentPiece!.x, currentPiece!.y + 1)) {
      currentPiece!.y++;
    }
    moveDown();
  }

  void updateScore(int clearedLines) {
    if (clearedLines == 0) {
      combo = 0;
      comboMessage = null;
      setState(() {});
      return;
    }

    combo++;
    lines += clearedLines;
    score += switch (clearedLines) {
      1 => 100 * level,
      2 => 300 * level,
      3 => 500 * level,
      4 => 800 * level,
      _ => 0
    };

    comboMessage = 'COMBO x$combo!';
    comboTimer?.cancel();
    comboTimer = Timer(const Duration(seconds: 2), () {
      comboMessage = null;
      setState(() {});
    });

    level = (lines ~/ 10) + 1;
    startTimer();
    setState(() {});
  }

  void moveLeft() {
    if (currentPiece == null || isPaused) return;
    if (board.isValidMove(
        currentPiece!, currentPiece!.x - 1, currentPiece!.y)) {
      setState(() {
        currentPiece!.x--;
      });
    }
  }

  void moveRight() {
    if (currentPiece == null || isPaused) return;
    if (board.isValidMove(
        currentPiece!, currentPiece!.x + 1, currentPiece!.y)) {
      setState(() {
        currentPiece!.x++;
      });
    }
  }

  void rotate() {
    if (currentPiece == null || isPaused) return;
    
    final originalRotation = currentPiece!.rotation;
    currentPiece!.rotate();
    
    // 회전 후 충돌이 발생하면 왼쪽이나 오른쪽으로 이동을 시도
    if (!board.isValidMove(currentPiece!, currentPiece!.x, currentPiece!.y)) {
      // 오른쪽 벽과 충돌하는 경우, 왼쪽으로 이동 시도
      for (int offset = 1; offset <= 2; offset++) {
        if (board.isValidMove(currentPiece!, currentPiece!.x - offset, currentPiece!.y)) {
          currentPiece!.x -= offset;
          setState(() {});
          return;
        }
      }
      
      // 왼쪽 벽과 충돌하는 경우, 오른쪽으로 이동 시도
      for (int offset = 1; offset <= 2; offset++) {
        if (board.isValidMove(currentPiece!, currentPiece!.x + offset, currentPiece!.y)) {
          currentPiece!.x += offset;
          setState(() {});
          return;
        }
      }
      
      // 이동이 불가능한 경우 원래 회전 상태로 복구
      currentPiece!.rotation = originalRotation;
      for (int i = 0; i < 4 - originalRotation; i++) {
        currentPiece!.rotate();
      }
    }
    
    setState(() {});
  }

  void dispose() {
    gameTimer?.cancel();
  }

  int getGhostPieceY() {
    if (currentPiece == null) return 0;

    int ghostY = currentPiece!.y;
    while (board.isValidMove(currentPiece!, currentPiece!.x, ghostY + 1)) {
      ghostY++;
    }
    return ghostY;
  }

  void getholdPiece() {
    if (!canHold || currentPiece == null || isPaused) return;
    
    if (holdPiece == null) {
      // 처음 홀드하는 경우
      holdPiece = Piece(type: currentPiece!.type);
      currentPiece = nextPiece;
      nextPiece = Piece(type: Random().nextInt(7) + 1);
    } else {
      // 이미 홀드된 블록이 있는 경우
      Piece temp = Piece(type: currentPiece!.type);
      currentPiece = Piece(type: holdPiece!.type);
      holdPiece = temp;
    }
    
    // 홀드한 블록의 위치 초기화
    currentPiece!.x = 3;
    currentPiece!.y = 0;
    
    canHold = false;  // 다음 블록이 바닥에 닿을 때까지 홀드 불가
    setState(() {});
  }
}
