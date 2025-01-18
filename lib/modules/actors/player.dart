import 'dart:async';

import 'package:dalvas_adventure/dalvas_adventure.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running, attacking }

enum PlayerDirection { left, right, idle }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<DalvasAdventure>, KeyboardHandler {
  String entity;
  Player({this.entity = 'King', position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation attackAnimation;

  /// Sprites stepTime from the creator's website.
  final double stepTime = 0.1;

  PlayerDirection playerdirection = PlayerDirection.idle;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isFacingRight = true;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerMoviment(dt);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD);

    if(isLeftKeyPressed && isRightKeyPressed){
      playerdirection = PlayerDirection.idle;
    } else if (isLeftKeyPressed){
      playerdirection = PlayerDirection.left;
    } else if(isRightKeyPressed){
      playerdirection = PlayerDirection.right;
    } else {
      playerdirection = PlayerDirection.idle;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11, Vector2(78, 58));
    runAnimation = _spriteAnimation('Run', 8, Vector2(78, 58));
    attackAnimation = _spriteAnimation('Attack', 3, Vector2(78, 58));

    /// List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
      PlayerState.attacking: attackAnimation,
    };

    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(
          String state, int frames, Vector2 textureSize) =>
      SpriteAnimation.fromFrameData(
          game.images.fromCache('Kings and Pigs/Sprites/$entity/$state.png'),
          SpriteAnimationData.sequenced(
              amount: frames, stepTime: stepTime, textureSize: textureSize));

  void _updatePlayerMoviment(double dt) {
    double dirX = 0.0;
    double dirY = 0.0;

    switch (playerdirection) {
      case PlayerDirection.left:
        if (isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = false;
        }
        current = PlayerState.running;
        dirX -= moveSpeed;
        break;
      case PlayerDirection.right:
        if (!isFacingRight) {
          flipHorizontallyAroundCenter();
          isFacingRight = true;
        }
        current = PlayerState.running;
        dirX += moveSpeed;
        break;
      case PlayerDirection.idle:
        current = PlayerState.idle;
        break;
      default:
    }

    velocity = Vector2(dirX, dirY);
    position += velocity * dt;
  }
}
