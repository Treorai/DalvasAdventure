import 'dart:async';

import 'package:dalvas_adventure/dalvas_adventure.dart';
import 'package:dalvas_adventure/modules/collisions/collision_block.dart';
import 'package:dalvas_adventure/modules/collisions/collision_handler.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum PlayerState { idle, running, attacking, jumping, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<DalvasAdventure>, KeyboardHandler {
  String entity;
  Player({this.entity = 'King', position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation attackAnimation;
  late final SpriteAnimation fallAnimation;
  late final SpriteAnimation jumpAnimation;

  /// Sprites stepTime from the creator's website.
  final double stepTime = 0.1;
  final double _gravity = 9.8;
  final double _jumpForce = 460;

  /// The max speed at the object falls.
  final double _terminalVelocity = 550;

  double horizontalMovement = 0;
  double moveSpeed = 100;
  Vector2 velocity = Vector2.zero();
  bool isAttacking = false;
  bool isOnGround = false;
  int jumpsLeft = 3;
  bool inputingJumpAction = false;
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
    _applyGravity(dt);
    _checkForVerticalCollisions();
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

    inputingJumpAction = keysPressed.contains(LogicalKeyboardKey.space);
    isAttacking = keysPressed.contains(LogicalKeyboardKey.keyQ);

    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11, Vector2(78, 58));
    runAnimation = _spriteAnimation('Run', 8, Vector2(78, 58));
    attackAnimation = _spriteAnimation('Attack', 3, Vector2(78, 58));
    jumpAnimation = _spriteAnimation('Jump', 1, Vector2(78,58));
    fallAnimation = _spriteAnimation('Fall', 1, Vector2(78, 58));

    /// List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runAnimation,
      PlayerState.attacking: attackAnimation,
      PlayerState.jumping: jumpAnimation,
      PlayerState.falling: fallAnimation,
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
    if(inputingJumpAction && jumpsLeft > 0){
      _jumpPlayer(dt);
    }
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _updatePlayerState() {
    if(isOnGround) {
      _resetJumps();
    }

    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }

    if (velocity.x > 0 || velocity.x < 0) {
      playerState = PlayerState.running;
    }

    if (velocity.y > 0 && !isOnGround){
      playerState = PlayerState.falling;
    }
    if (velocity.y < 0 && !isOnGround){
      playerState = PlayerState.jumping;
    }

    if(isAttacking){
      playerState = PlayerState.attacking;
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
            break;
          }
          if (velocity.x < 0) {
            velocity.x = -0.01;
            position.x = block.x + width + block.width;
            break;
          }
        }
      }
    }
  }

  /// Must be called between horizontal and vertical collision handlers.
  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkForVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnGround = true;
            break;
          }
        }
        break;
      } else {
        if (checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - height;
            isOnGround = true;
            break;
          }
          if(velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height;
          }
        }
      }
    }
  }
  
  void _jumpPlayer(double dt) {
    isOnGround = false;
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    inputingJumpAction = false;
    jumpsLeft += -1;
  }

  void _resetJumps(){
    jumpsLeft = 3;
  }
}
