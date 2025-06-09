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
              children:
                  Difficulty.values.map((difficulty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF3E2723,
                          ).withValues(alpha: 0.7),
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
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
