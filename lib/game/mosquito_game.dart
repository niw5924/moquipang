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

    final bgSprite = await Sprite.load('background.png');
    add(
      SpriteComponent(
        sprite: bgSprite,
        size: size,
        position: Vector2.zero(),
        priority: 0,
      ),
    );

    for (int i = 0; i < mosquitoCount; i++) {
      add(await _createRandomMosquito());
    }

    add(SoundToggleButton(position: Vector2(size.x - (40 + 16), 16)));
    add(TimerTextComponent(position: Vector2(16, 16)));
    add(RestartButtonComponent(position: size / 2));
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
    // BGM은 싱글톤 외부 리소스이므로 여기서 명시적으로 정리해야 함(모기 등 일반 컴포넌트와 다름)
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
    super.priority = 10,
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

class SoundToggleButton extends SpriteComponent
    with TapCallbacks, HasGameReference<MosquitoGame> {
  late Sprite soundOnSprite;
  late Sprite soundOffSprite;
  bool isSoundOn = true;

  SoundToggleButton({required Vector2 position, super.priority = 2})
    : super(size: Vector2.all(40), position: position);

  @override
  Future<void> onLoad() async {
    soundOnSprite = await Sprite.load('sound_on_icon.png');
    soundOffSprite = await Sprite.load('sound_off_icon.png');
    sprite = soundOnSprite;
  }

  @override
  void update(double dt) {
    super.update(dt);

    final mosquitoes = game.children.whereType<MosquitoComponent>();

    if (isSoundOn && mosquitoes.isNotEmpty) {
      if (!FlameAudio.bgm.isPlaying) {
        FlameAudio.bgm.play('bgm.mp3', volume: 0.6);
      }
    } else {
      if (FlameAudio.bgm.isPlaying) {
        FlameAudio.bgm.stop();
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    isSoundOn = !isSoundOn;
    sprite = isSoundOn ? soundOnSprite : soundOffSprite;
  }
}

class TimerTextComponent extends TextComponent
    with HasGameReference<MosquitoGame> {
  double _elapsedTime = 0.0;

  TimerTextComponent({required Vector2 position})
    : super(
        position: position,
        priority: 1,
        text: '0.0s',
        anchor: Anchor.topLeft,
      );

  @override
  void update(double dt) {
    super.update(dt);

    final mosquitoes = game.children.whereType<MosquitoComponent>();
    if (mosquitoes.isEmpty) return;

    _elapsedTime += dt;
    text = '${_elapsedTime.toStringAsFixed(1)}s';
  }
}

class RestartButtonComponent extends SpriteComponent {
  RestartButtonComponent({required Vector2 position})
    : super(
        size: Vector2.all(64),
        position: position,
        anchor: Anchor.center,
        priority: 20,
      );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('restart_icon.png');
  }
}
