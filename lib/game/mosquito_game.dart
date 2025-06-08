import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';

class MosquitoGame extends FlameGame
    with TapCallbacks, HasGameReference<MosquitoGame> {
  final int mosquitoCount = 5;
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final bgSprite = await Sprite.load('background.png');
    final bg = SpriteComponent(
      sprite: bgSprite,
      size: size,
      position: Vector2.zero(),
      priority: -1,
    );
    add(bg);

    print('📱 전체화면 사이즈: ${size.x} x ${size.y}');

    for (int i = 0; i < mosquitoCount; i++) {
      final mosquito = await _createRandomMosquito();
      print('🦟 ${i + 1}번 모기 위치: ${mosquito.position}');
      add(mosquito);
    }
  }

  Future<MosquitoComponent> _createRandomMosquito() async {
    final mosquitoSize = Vector2(60, 60);
    final sprite = await Sprite.load('mosquito.png');
    final double x = _random.nextDouble() * (size.x - mosquitoSize.x);
    final double y = _random.nextDouble() * (size.y - mosquitoSize.y);
    return MosquitoComponent(
      sprite: sprite,
      size: mosquitoSize,
      position: Vector2(x, y),
    );
  }
}

class MosquitoComponent extends SpriteComponent
    with TapCallbacks, HasGameReference<MosquitoGame> {
  late Vector2 velocity;

  MosquitoComponent({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
  }) : super(sprite: sprite, size: size, position: position) {
    final speed = 100.0;
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
    print('🦟 모기 클릭! 위치: $position');
    FlameAudio.play('squish_pop.mp3');
    removeFromParent();
  }
}
