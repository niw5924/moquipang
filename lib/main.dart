import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/mosquito_game.dart';
import 'game/difficulty.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache.loadAll(['bgm.mp3', 'squish_pop.mp3']);
  FlameAudio.bgm.initialize();
  runApp(const MaterialApp(home: DifficultySelectPage()));
}

class DifficultySelectPage extends StatelessWidget {
  const DifficultySelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 게임 타이틀
                Text(
                  '모퀴팡',
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    foreground:
                        Paint()
                          ..shader = const LinearGradient(
                            colors: [Color(0xFF66BB6A), Color(0xFFB9F6CA)],
                          ).createShader(Rect.fromLTWH(0, 0, 300, 80)),
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 10.0,
                        color: Colors.black.withValues(alpha: 0.5),
                      ),
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 6.0,
                        color: Color(0xFFB9F6CA).withValues(alpha: 0.5),
                      ),
                    ],
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 40),
                // 난이도 버튼
                ...Difficulty.values.map((difficulty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E2723).withAlpha(180),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0xFFD7CCC8),
                            width: 2,
                          ),
                        ),
                        elevation: 6,
                        shadowColor: Colors.black54,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => GameWidget(
                                  game: MosquitoGame(difficulty: difficulty),
                                ),
                          ),
                        );
                      },
                      child: Text(difficulty.label),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
