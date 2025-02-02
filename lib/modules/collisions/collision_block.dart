import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
  }) : super(
          position: position,
          size: size,
        ) {
    debugMode = kDebugMode;
  }
}
