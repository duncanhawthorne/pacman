import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:pacman_roll/flame_game/pacman_game.dart';
import 'package:provider/provider.dart';

import '../level_selection/levels.dart';
import '../style/palette.dart';

/// This dialog is shown when a level is lost.

class GameLoseDialog extends StatelessWidget {
  const GameLoseDialog({
    super.key,
    required this.level,
    required this.game,
  });

  /// The properties of the level that was just finished.
  final GameLevel level;
  final PacmanGame game;

  @override
  Widget build(BuildContext context) {
    final palette = context.read<Palette>();
    return Center(
      child: NesContainer(
        width: 420,
        height: 300,
        backgroundColor: palette.backgroundPlaySession.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Game Over',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Text(
              "Dots left: ${game.world.pelletsRemainingNotifier.value}",
              style: const TextStyle(fontFamily: 'Press Start 2P'),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            if (true) ...[
              NesButton(
                onPressed: () {
                  context.go('/');
                },
                type: NesButtonType.primary,
                child: const Text('Retry',
                    style: TextStyle(fontFamily: 'Press Start 2P')),
              ),
              const SizedBox(height: 16),
            ],
            //NesButton(
            //  onPressed: () {
            //    context.go('/play');
            //  },
            //  type: NesButtonType.normal,
            //  child: const Text('Level selection'),
            //),
          ],
        ),
      ),
    );
  }
}
