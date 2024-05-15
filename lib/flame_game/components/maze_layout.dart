import 'package:flutter/cupertino.dart';

import '../constants.dart';
import '../helper.dart';
import 'package:flame/components.dart';
import 'wall.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'super_pellet.dart';
import 'mini_pellet.dart';

import 'package:flame/extensions.dart';

const mazeWallWidthFactor = 0.7;

int getMazeIntWidth() {
  return wrappedMazeLayout.isEmpty ? 0 : wrappedMazeLayout[0].length;
}

void addPelletsAndSuperPellets(
    Forge2DWorld world, ValueNotifier pelletsRemainingNotifier) {
  pelletsRemainingNotifier.value = 0;
  double scale = getSingleSquareWidth();
  for (var i = 0; i < wrappedMazeLayout.length; i++) {
    for (var j = 0; j < wrappedMazeLayout[i].length; j++) {
      Vector2 center = Vector2(j + 1 / 2 - wrappedMazeLayout[0].length / 2,
              i + 1 / 2 - wrappedMazeLayout.length / 2) *
          scale;
      if (wrappedMazeLayout[i][j] == 0) {
        world.add(MiniPelletCircle(position: center));
      }
      if (wrappedMazeLayout[i][j] == 3) {
        world.add(SuperPelletCircle(position: center));
      }
    }
  }
}

class MazeWallSquareVisual extends RectangleComponent {
  MazeWallSquareVisual(
      {required super.position, required widthx, required heightx})
      : super(
            size: Vector2(widthx, heightx),
            anchor: Anchor.center,
            paint: blackBackgroundPaint);
  double widthx = 0;
  double heightx = 0;
}

class MazeWallCircleVisual extends CircleComponent {
  MazeWallCircleVisual({required super.radius, required super.position})
      : super(anchor: Anchor.center, paint: blackBackgroundPaint); //NOTE BLACK
}

void addMazeWalls(world) {
  double scale = getSingleSquareWidth();
  if (mazeOn) {
    for (var i = 0; i < wrappedMazeLayout.length; i++) {
      for (var j = 0; j < wrappedMazeLayout[0].length; j++) {
        Vector2 center = Vector2(j + 1 / 2 - wrappedMazeLayout[0].length / 2,
                i + 1 / 2 - wrappedMazeLayout.length / 2) *
            scale;
        if (wrappedMazeLayout[i][j] == 1) {
          world.add(MazeWallCircleGround(center, scale / 2));
          if (j + 1 < wrappedMazeLayout[0].length &&
              wrappedMazeLayout[i][j + 1] == 1) {
            world.add(MazeWallRectangleGround(
                center + Vector2(scale / 2, 0), scale, scale));
          }
          if (i + 1 < wrappedMazeLayout.length &&
              wrappedMazeLayout[i + 1][j] == 1) {
            world.add(MazeWallRectangleGround(
                center + Vector2(0, scale / 2), scale, scale));
          }
        }
      }
    }

    for (var i = 0; i < wrappedMazeLayout.length; i++) {
      for (var j = 0; j < wrappedMazeLayout[0].length; j++) {
        Vector2 center = Vector2(j + 1 / 2 - wrappedMazeLayout[0].length / 2,
                i + 1 / 2 - wrappedMazeLayout.length / 2) *
            scale;
        if (wrappedMazeLayout[i][j] == 1) {
          world.add(MazeWallCircleVisual(
              position: center,
              radius: getSingleSquareWidth() / 2 * mazeWallWidthFactor));

          if (j + 1 < wrappedMazeLayout[i].length &&
              wrappedMazeLayout[i][j + 1] == 1) {
            world.add(MazeWallSquareVisual(
                position: center + Vector2(scale / 2, 0),
                widthx: scale,
                heightx: scale * mazeWallWidthFactor));
          }
          if (i + 1 < wrappedMazeLayout.length &&
              wrappedMazeLayout[i + 1][j] == 1) {
            world.add(MazeWallSquareVisual(
                position: center + Vector2(0, scale / 2),
                widthx: scale * mazeWallWidthFactor,
                heightx: scale));
          }
        }
      }
    }
  }
}

List<Component> createBoundaries(CameraComponent camera) {
  final Rect visibleRect = camera.visibleWorldRect;
  final Vector2 topLeft = visibleRect.topLeft.toVector2();
  final Vector2 topRight = visibleRect.topRight.toVector2();
  final Vector2 bottomRight = visibleRect.bottomRight.toVector2();
  final Vector2 bottomLeft = visibleRect.bottomLeft.toVector2();

  return [
    Wall(topLeft, topRight),
    Wall(topRight, bottomRight),
    Wall(bottomLeft, bottomRight),
    Wall(topLeft, bottomLeft),
  ];
}