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
  final Random random = Random();

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
      add(await createRandomMosquito());
    }

    add(BestTimeText(position: Vector2(16, 16)));
    add(TimerText(position: Vector2(16, 48)));
    add(SoundToggleButton(position: Vector2(size.x - (40 + 16), 16)));
    add(RestartButton(position: size / 2));
  }

  Future<Mosquito> createRandomMosquito() async {
    final sprite = await Sprite.load('mosquito.png');
    final mosquitoSize = Vector2(60, 60);
    final x = random.nextDouble() * (size.x - mosquitoSize.x);
    final y = random.nextDouble() * (size.y - mosquitoSize.y);
    return Mosquito(
      sprite: sprite,
      size: mosquitoSize,
      position: Vector2(x, y),
      speed: difficulty.speed,
    );
  }

  @override
  void onRemove() {
    /// BGM은 싱글톤 외부 리소스이므로 여기서 명시적으로 정리해야 함(모기 등 일반 컴포넌트와 다름)
    FlameAudio.bgm.stop();
    super.onRemove();
  }
}

class Mosquito extends SpriteComponent
    with TapCallbacks, HasGameReference<MosquitoGame> {
  late Vector2 velocity;

  Mosquito({
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

  /// TODO: 베스트 타임 저장
  @override
  void onTapDown(TapDownEvent event) {
    FlameAudio.play('squish_pop.mp3');
    removeFromParent();
  }
}

class BestTimeText extends TextComponent with HasGameReference<MosquitoGame> {
  BestTimeText({required Vector2 position})
    : super(
        position: position,
        priority: 1,
        text: '🏆 -',
        anchor: Anchor.topLeft,
      );

  void setBestTime(double? time) {
    if (time == null) {
      text = '🏆 -';
    } else {
      text = '🏆 ${time.toStringAsFixed(1)}s';
    }
  }
}

class TimerText extends TextComponent with HasGameReference<MosquitoGame> {
  double elapsedTime = 0.0;

  TimerText({required Vector2 position})
    : super(
        position: position,
        priority: 2,
        text: '0.0s',
        anchor: Anchor.topLeft,
      );

  @override
  void update(double dt) {
    super.update(dt);

    final mosquitoes = game.children.whereType<Mosquito>();
    if (mosquitoes.isEmpty) return;

    elapsedTime += dt;
    text = '${elapsedTime.toStringAsFixed(1)}s';
  }
}

class SoundToggleButton extends SpriteComponent
    with TapCallbacks, HasGameReference<MosquitoGame> {
  late Sprite soundOnSprite;
  late Sprite soundOffSprite;
  bool isSoundOn = true;

  SoundToggleButton({required Vector2 position, super.priority = 3})
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

    final mosquitoes = game.children.whereType<Mosquito>();
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

class RestartButton extends SpriteComponent
    with HasGameReference<MosquitoGame>, HasVisibility, TapCallbacks {
  RestartButton({required Vector2 position})
    : super(
        size: Vector2.all(64),
        position: position,
        anchor: Anchor.center,
        priority: 4,
      );

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('restart_icon.png');
    isVisible = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isVisible) return;

    final mosquitoes = game.children.whereType<Mosquito>();
    if (mosquitoes.isEmpty) {
      isVisible = true;
    }
  }

  @override
  Future<void> onTapDown(TapDownEvent event) async {
    isVisible = false;

    final timerText = game.children.whereType<TimerText>().first;
    timerText.elapsedTime = 0.0;
    timerText.text = '0.0s';

    game.children.whereType<Mosquito>().forEach((m) => m.removeFromParent());

    for (int i = 0; i < game.mosquitoCount; i++) {
      game.add(await game.createRandomMosquito());
    }

    final soundButton = game.children.whereType<SoundToggleButton>().first;
    final shouldPlay = soundButton.isSoundOn;

    if (shouldPlay && !FlameAudio.bgm.isPlaying) {
      FlameAudio.bgm.play('bgm.mp3', volume: 0.6);
    }
  }
}
