import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'game/mosquito_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.audioCache.loadAll(['bgm.mp3', 'squish_pop.mp3']);
  FlameAudio.bgm.initialize();
  FlameAudio.bgm.play('bgm.mp3', volume: 0.6);
  runApp(GameWidget(game: MosquitoGame()));
}
