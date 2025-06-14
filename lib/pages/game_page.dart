import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import '../game/mosquito_game.dart';
import '../widgets/confirm_dialog.dart';

class GamePage extends StatefulWidget {
  final MosquitoGame game;

  const GamePage({super.key, required this.game});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool isBgmPlaying = true;

  void _toggleBgm() {
    setState(() {
      if (isBgmPlaying) {
        FlameAudio.bgm.pause();
      } else {
        FlameAudio.bgm.resume();
      }
      isBgmPlaying = !isBgmPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final confirmed = await showDialog<bool>(
              context: context,
              builder:
                  (context) => const ConfirmDialog(
                    title: '게임 종료',
                    message: '정말로 게임을 종료하시겠습니까?',
                    cancelText: '아니오',
                    confirmText: '종료하기',
                  ),
            );
            if (confirmed == true) {
              Navigator.of(context).pop();
            }
          },
          child: GameWidget(game: widget.game),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: IconButton(
            icon: Icon(
              isBgmPlaying ? Icons.music_note : Icons.music_off,
              color: Colors.white,
            ),
            onPressed: _toggleBgm,
          ),
        ),
      ],
    );
  }
}
