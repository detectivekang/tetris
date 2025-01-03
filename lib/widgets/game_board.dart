import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../game/tetris_game.dart';
import '../game/board.dart';
import '../game/piece.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math' show min, pi;

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late TetrisGame game;
  final audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    game = TetrisGame(setState: setState);
    game.startGame();
    initAudio();
  }

  void initAudio() async {
    // 임시로 음악 기능 비활성화
    // await audioPlayer.setSource(AssetSource('music/tetris_theme.mp3'));
    // await audioPlayer.setReleaseMode(ReleaseMode.loop);
    // await audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 800),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 300,
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: RawKeyboardListener(
                focusNode: FocusNode()..requestFocus(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.arrowLeft:
              game.moveLeft();
            case LogicalKeyboardKey.arrowRight:
              game.moveRight();
            case LogicalKeyboardKey.arrowDown:
              game.moveDown();
            case LogicalKeyboardKey.space:
              game.hardDrop();
            case LogicalKeyboardKey.arrowUp:
              game.rotate();
                      case LogicalKeyboardKey.keyP:
              game.togglePause();
                      case LogicalKeyboardKey.keyC:
                        game.getholdPiece();
                    }
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Board.columns,
                    ),
                    itemCount: Board.rows * Board.columns,
                    itemBuilder: (context, index) {
                      int x = index % Board.columns;
                      int y = index ~/ Board.columns;

                      // 현재 블록 위치
                      bool isCurrentPiece =
                          game.currentPiece?.isOccupying(x, y) == true;

                      // 고스트 블록 위치 (현재 블록의 y 위치와 상관없이 항상 계산)
                      bool isGhostPiece = !isCurrentPiece &&
                          game.currentPiece != null &&
                          game.currentPiece!.isOccupying(
                              x,
                              y + game.currentPiece!.y - game.getGhostPieceY());

                      int type = isCurrentPiece
                          ? game.currentPiece!.type
                          : game.board.board[y][x];

                      return Container(
                        decoration: BoxDecoration(
                          color: isGhostPiece
                              ? Piece.colors[game.currentPiece!.type]
                                  ?.withOpacity(0.2)
                              : (type == 0
                                  ? Colors.black12
                                  : Piece.colors[type]),
                          border: Border.all(
                            color: Colors.black26,
                            width: 1,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
            Container(
              width: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Next Piece:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        int x = index % 4;
                        int y = index ~/ 4;
                        bool isOccupied =
                            y < (game.nextPiece?.shape.length ?? 0) &&
                                x < (game.nextPiece?.shape[y].length ?? 0) &&
                                (game.nextPiece?.shape[y][x] ?? 0) == 1;

    return Container(
      decoration: BoxDecoration(
                            color: isOccupied
                                ? Piece.colors[game.nextPiece?.type ?? 0]
                                : Colors.transparent,
        border: Border.all(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text('Score: ${game.score}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  if (game.comboMessage != null)
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 300),
                      builder: (context, value, child) {
                        // 콤보 수에 따른 색상 변화
                        final color = switch (game.combo) {
                          <= 2 => Colors.orange,
                          <= 4 => Colors.pink,
                          <= 6 => Colors.purple,
                          _ => HSLColor.fromAHSL(
                                  1, (game.combo * 25) % 360, 1, 0.5)
                              .toColor(),
                        };

                        return Transform.scale(
                          scale: 1.0 +
                              (0.2 * value) +
                              (min(game.combo * 0.05, 0.3).toDouble()),
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                color,
                                color.withBlue(255),
                                color.withRed(255),
                              ],
                              transform: GradientRotation(
                                  (value * 2 * pi + (game.combo * 0.2))
                                      .toDouble()),
                            ).createShader(bounds),
                            child: Text(
                              game.comboMessage!,
                              style: TextStyle(
                                fontSize:
                                    min((20 + game.combo).toDouble(), 32.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  for (var i = 1; i <= min(game.combo, 4); i++)
                                    Shadow(
                                      color: color.withOpacity(0.6),
                                      blurRadius: (10 * i).toDouble(),
                                      offset: const Offset(0, 0),
                                    ),
                                ],
                              ),
              ),
      ),
    );
                      },
                    ),
                  const SizedBox(height: 20),
                  Text('Level: ${game.level}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  Text('Lines: ${game.lines}',
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 40),
                  if (game.isPaused)
                    const Text('PAUSED',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  if (game.isGameOver)
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                        Text('GAME OVER',
                style: TextStyle(
                                fontSize: 24,
                  fontWeight: FontWeight.bold,
                                color: Colors.red)),
                        SizedBox(height: 10),
                        Text('Press SPACE to restart',
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Text('Hold:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, index) {
                        int x = index % 4;
                        int y = index ~/ 4;
                        bool isOccupied = game.holdPiece != null &&
                            y < game.holdPiece!.shape.length &&
                            x < game.holdPiece!.shape[y].length &&
                            game.holdPiece!.shape[y][x] == 1;

                        return Container(
                          decoration: BoxDecoration(
                            color: isOccupied
                                ? Piece.colors[game.holdPiece!.type]
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.black26,
                              width: 1,
                            ),
                          ),
                        );
                    },
                  ),
                ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('게임 도움말'),
                          content: const SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('조작 방법:', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text('← → : 좌우 이동'),
                                Text('↑ : 블록 회전'),
                                Text('↓ : 한 칸 아래로'),
                                Text('Space : 즉시 떨어뜨리기'),
                                Text('P : 일시정지'),
                                Text('C : 블록 홀드'),
                                SizedBox(height: 20),
                                Text('게임 규칙:', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text('- 한 줄을 가득 채우면 해당 줄이 제거됩니다'),
                                Text('- 연속으로 줄을 제거하면 콤보 점수가 추가됩니다'),
                                Text('- 10줄을 제거할 때마다 레벨이 올라갑니다'),
                                Text('- 레벨이 올라갈수록 블록이 더 빨리 떨어집니다'),
                                Text('- 블록이 천장에 닿으면 게임 오버됩니다'),
            ],
          ),
        ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('확인'),
          ),
        ],
      ),
    );
                    },
                    icon: const Icon(Icons.help_outline),
                    label: const Text('도움말'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
