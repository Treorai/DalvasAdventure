import 'dart:math' as math;
import 'package:flame/components.dart';

mixin ExtendedPositionComponent on PositionComponent {
  void flipHorizontallyAroundAnchor(Anchor anchorPoint) {
      final delta = (1 - 2 * anchorPoint.x) * width * transform.scale.x;
      transform.x += delta * math.cos(transform.angle);
      transform.y += delta * math.sin(transform.angle);
    transform.flipHorizontally();
  }
}