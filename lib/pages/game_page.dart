import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/mosquito_game.dart';
import '../widgets/confirm_dialog.dart';

class GamePage extends StatelessWidget {
  final MosquitoGame game;

  const GamePage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
      child: GameWidget(game: game),
    );
  }
}
