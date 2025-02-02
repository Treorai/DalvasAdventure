import 'dart:async';

import 'package:dalvas_adventure/dalvas_adventure.dart';
import 'package:dalvas_adventure/modules/collisions/collision_block.dart';
import 'package:dalvas_adventure/modules/collisions/collision_handler.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running, attacking }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<DalvasAdventure>, KeyboardHandler {
  String entity;
  Player({this.entity = 'King', position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation attackAnimation;

  /// Sprites stepTime from the creator's website.
  final double stepTime = 0.1;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() {
    debugMode = kDebugMode;
    _loadAllAnimations();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMoviment(dt);
    _checkForHorizontalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);

    horizontalMovement += isLeftKeyPressed ? -1 : 0;
    horizontalMovement += isRightKeyPressed ? 1 : 0;

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

  /// Handles character's x axis movement. The y axis movement is handled by the gravity propriety.
  void _updatePlayerMoviment(double dt) {
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    }

    current = playerState;
  }

  void _checkForHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0.01;
            position.x = block.x - width;
          }
          if (velocity.x < 0) {
            velocity.x = -0.01;
            position.x = block.x + width + block.width;
          }
        }
      }
    }
  }
}
