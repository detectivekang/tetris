import 'package:flutter/material.dart';
import '../widgets/game_board.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'TETRIS',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Scaffold(body: GameBoard())),
                  );
                },
                child: const Text('게임 시작', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Text('랭킹'),
                      content: Text('랭킹 기능은 준비 중입니다...'),
                    ),
                  );
                },
                child: const Text('랭킹 보기', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
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
                            Text('조작 방법:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text('← → : 좌우 이동'),
                            Text('↑ : 블록 회전'),
                            Text('↓ : 한 칸 아래로'),
                            Text('Space : 즉시 떨어뜨리기'),
                            Text('P : 일시정지'),
                            Text('C : 블록 홀드'),
                            SizedBox(height: 20),
                            Text('게임 규칙:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
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
                          child: Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('도움말', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
