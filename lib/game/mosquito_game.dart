import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

class MosquitoGame extends FlameGame
    with TapCallbacks, HasGameReference<MosquitoGame> {
  final int mosquitoCount = 5;
  final Random _random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ✅ 전체화면 사이즈 프린트
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
  MosquitoComponent({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
  }) : super(sprite: sprite, size: size, position: position);

  @override
  void onTapDown(TapDownEvent event) {
    // ✅ 클릭 시 위치 프린트
    print('🦟 모기 클릭! 위치: $position');
    removeFromParent();
  }
}
