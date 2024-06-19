import 'dart:math';

import 'package:elapsed_time_display/elapsed_time_display.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import 'components/pacman_icons.dart';
import 'components/pacman_sprites.dart';
import 'game_lose_dialog.dart';
import 'game_won_dialog.dart';
import 'pacman_game.dart';

/// This widget defines the properties of the game screen.
///
/// It mostly sets up the overlays (widgets shown on top of the Flame game) and
/// the gets the [AudioController] from the context and passes it in to the
/// [PacmanGame] class so that it can play audio.

const double statusWidgetHeightFactor = 0.75;
const statusWidgetHeight = 30;

class GameScreen extends StatelessWidget {
  const GameScreen({required this.level, super.key});

  final GameLevel level;

  static const String loseDialogKey = 'lose_dialog';
  static const String wonDialogKey = 'won_dialog';
  static const String backButtonKey = 'back_button';
  static const String statusOverlayKey = 'status_overlay';

  @override
  Widget build(BuildContext context) {
    context.watch<Palette>();
    final audioController = context.read<AudioController>();
    final palette = context.read<Palette>();
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GameWidget<PacmanGame>(
          key: const Key('play session'),
          game: PacmanGame(
            level: level,
            playerProgress: context.read<PlayerProgress>(),
            audioController: audioController,
            palette: palette,
          ),
          overlayBuilderMap: {
            backButtonKey: (BuildContext context, PacmanGame game) {
              return backButtonWidget(context, game);
            },
            statusOverlayKey: (BuildContext context, PacmanGame game) {
              return statusOverlayWidget(context, game);
            },
            loseDialogKey: (BuildContext context, PacmanGame game) {
              return GameLoseDialog(
                level: level,
              );
            },
            wonDialogKey: (BuildContext context, PacmanGame game) {
              return GameWonDialog(
                  level: level,
                  levelCompletedIn: game.stopwatchSeconds,
                  game: game);
            },
          },
        ),
      ),
    );
  }
}

Widget backButtonWidget(BuildContext context, PacmanGame game) {
  return Positioned(
    top: 20,
    left: 30,
    child: NesButton(
      type: NesButtonType.normal,
      onPressed: () {
        GoRouter.of(context).go("/");
      },
      child: NesIcon(
          iconData: NesIcons.leftArrowIndicator, size: const Size(15, 15)),
    ),
  );
}

Widget statusOverlayWidget(BuildContext context, PacmanGame game) {
  return Positioned(
    top: 27,
    right: 30,
    child: Container(
      height: statusWidgetHeight.toDouble(),
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ValueListenableBuilder<int>(
            valueListenable: game.world.numberOfDeathsNotifier,
            builder: (BuildContext context, int value, Widget? child) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                      3 - game.world.numberOfDeathsNotifier.value,
                      (index) => Padding(
                          padding: const EdgeInsets.fromLTRB(
                              4 * statusWidgetHeightFactor,
                              0,
                              4 * statusWidgetHeightFactor,
                              0),
                          child: Transform.rotate(
                              angle: 2 * pi / 2,
                              child: index == 0
                                  ? animatedPacmanIcon(game,
                                      game.world.pacmanDyingNotifier.value)
                                  : pacmanIconCache[
                                      pacmanRenderFracIncrementsNumber ~/
                                          4]))));
            },
          ),
          const SizedBox(width: 20 * statusWidgetHeightFactor, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 0, 0),
            child: ElapsedTimeDisplay(
              startTime: DateTime.now(), //actually ignored
              interval: const Duration(milliseconds: 100),
              style: const TextStyle(
                  fontSize: 18 * statusWidgetHeightFactor,
                  color: Colors.white,
                  fontFamily: 'Press Start 2P'),
              formatter: (elapsedTime) {
                return game.stopwatchSeconds.toStringAsFixed(1).padLeft(4, " ");
              },
            ),
          ),
        ],
      ),
    ),
  );
}
