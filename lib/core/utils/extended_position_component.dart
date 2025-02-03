import 'dart:math' as math;
import 'package:flame/components.dart';

mixin ExtendedPositionComponent on PositionComponent {
  /// Flip the component horizontally around a given anchor point.
  void flipHorizontallyAroundAnchor(Anchor anchorPoint) {
    if (anchor.x != 0.5) {
      final delta = (1 - 2 * anchorPoint.x) * width * transform.scale.x;
      transform.x += delta * math.cos(transform.angle);
      transform.y += delta * math.sin(transform.angle);
    }
    transform.flipHorizontally();
  }

  /// Flip the component vertically around a given anchor point.
  void flipVerticallyAroundAnchor(Anchor anchorPoint) {
    if (anchor.y != 0.5) {
      final delta = (1 - 2 * anchorPoint.y) * height * transform.scale.y;
      transform.x += -delta * math.sin(transform.angle);
      transform.y += delta * math.cos(transform.angle);
    }
    transform.flipVertically();
  }
}
