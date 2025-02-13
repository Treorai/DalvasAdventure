import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

mixin ExtendedPositionComponent on PositionComponent {
  /// Flip the component horizontally around the center ff a given ShapeHitbox.
  void flipHorizontallyAroundHitboxCenter(ShapeHitbox hitboxComponent) {
    final delta = (1 - 2 * anchor.x) *
        (hitboxComponent.position.x * 2 + hitboxComponent.width) *
        transform.scale.x;
    transform.x += delta * math.cos(transform.angle);
    transform.y += delta * math.sin(transform.angle);

    transform.flipHorizontally();
  }

  /// Flip the component vertically around the center of a given ShapeHitbox.
  void flipVerticallyAroundHitboxCenter(ShapeHitbox hitboxComponent) {
    final delta = (1 - 2 * anchor.y) *
        (hitboxComponent.position.y * 2 + hitboxComponent.height) *
        transform.scale.y;
    transform.x += -delta * math.sin(transform.angle);
    transform.y += delta * math.cos(transform.angle);

    transform.flipVertically();
  }
}
