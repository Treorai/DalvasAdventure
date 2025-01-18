import 'dart:async';

import 'package:dalvas_adventure/dalvas_adventure.dart';
import 'package:flame/components.dart';

enum PlayerState { idle, running, attacking }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<DalvasAdventure> {
  String entity;
  Player({required this.entity, position}) : super(position: position);

  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation attackAnimation;

  /// Sprites stepTime from the creator's website.
  final double stepTime = 0.1;

  @override
  FutureOr<void> onLoad() {
    _loadAllAnimations();
    return super.onLoad();
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
          game.images
              .fromCache('Kings and Pigs/Sprites/$entity/$state.png'),
          SpriteAnimationData.sequenced(
              amount: frames, stepTime: stepTime, textureSize: textureSize));
}
