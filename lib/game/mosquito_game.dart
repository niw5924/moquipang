import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import '../models/difficulty.dart';

class MosquitoGame extends FlameGame
    with TapCallbacks, HasGameReference<MosquitoGame> {
  final Difficulty difficulty;
  final int mosquitoCount = 5;
  final Random _random = Random();

  MosquitoGame({required this.difficulty});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    FlameAudio.bgm.play('bgm.mp3', volume: 0.6);
    final bgSprite = await Sprite.load('background.png');
    final bg = SpriteComponent(
      sprite: bgSprite,
      size: size,
      position: Vector2.zero(),
      priority: -1,
    );
    add(bg);
    for (int i = 0; i < mosquitoCount; i++) {
      final mosquito = await _createRandomMosquito();
      add(mosquito);
    }
  }

  Future<MosquitoComponent> _createRandomMosquito() async {
    final sprite = await Sprite.load('mosquito.png');
    final mosquitoSize = Vector2(60, 60);
    final x = _random.nextDouble() * (size.x - mosquitoSize.x);
    final y = _random.nextDouble() * (size.y - mosquitoSize.y);
    return MosquitoComponent(
      sprite: sprite,
      size: mosquitoSize,
      position: Vector2(x, y),
      speed: difficulty.speed,
    );
  }

  @override
  void onRemove() {
    FlameAudio.bgm.stop();
    super.onRemove();
  }
}

class MosquitoComponent extends SpriteComponent
    with TapCallbacks, HasGameReference<MosquitoGame> {
  late Vector2 velocity;

  MosquitoComponent({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
    required double speed,
  }) : super(sprite: sprite, size: size, position: position) {
    final angle = Random().nextDouble() * 2 * pi;
    velocity = Vector2(cos(angle), sin(angle)) * speed;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
    if (position.x <= 0 || position.x + size.x >= game.size.x) {
      velocity.x = -velocity.x;
    }
    if (position.y <= 0 || position.y + size.y >= game.size.y) {
      velocity.y = -velocity.y;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.play('squish_pop.mp3');
    removeFromParent();
  }
}
