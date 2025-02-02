import 'dart:async';
import 'dart:io';

import 'package:dalvas_adventure/modules/common/player.dart';
import 'package:dalvas_adventure/modules/common/level.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class DalvasAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color.fromARGB(255, 63, 56, 81);

  late final CameraComponent cam;
  Player player = Player(entity: 'King');
  late JoystickComponent joystick;
  bool showJoystick = Platform.isAndroid ? true : false;

  @override
  FutureOr<void> onLoad() async {
    //TODO: await images.loadAll(fileNames);
    await images.loadAllImages();

    final world = Level(screenName: 'screen-00', player: player);

    cam = CameraComponent.withFixedResolution(
        world: world, width: 1280, height: 768);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    if (showJoystick) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showJoystick) {
      updateJoystick(dt);
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(sprite: Sprite(images.fromCache('HUD/Knob.png'))),
      background:
          SpriteComponent(sprite: Sprite(images.fromCache('HUD/Joystick.png'))),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );
    add(joystick);
  }

  void updateJoystick([double? dt]) {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerdirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerdirection = PlayerDirection.right;
        break;
      case JoystickDirection.up:
      case JoystickDirection.down:
      default:
        player.playerdirection = PlayerDirection.idle;
    }
  }
}
