import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';
import 'models/difficulty.dart';
import 'game/mosquito_game.dart';
import 'pages/game_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache.loadAll(['bgm.mp3', 'squish_pop.mp3']);
  FlameAudio.bgm.initialize();
  runApp(
    MaterialApp(
      builder: (context, child) => SafeArea(child: child!),
      home: const DifficultySelectPage(),
    ),
  );
}

class DifficultySelectPage extends StatelessWidget {
  const DifficultySelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                        blurRadius: 10,
                        color: Colors.black.withAlpha(100),
                      ),
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: 6,
                        color: Color(0xFFB9F6CA).withAlpha(100),
                      ),
                    ],
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ...Difficulty.values.map((difficulty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3E2723).withAlpha(180),
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
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
                                (_) => GamePage(
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
