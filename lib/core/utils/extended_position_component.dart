import 'dart:math' as math;
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

mixin ExtendedPositionComponent on PositionComponent {
  /// Flip the component horizontally from a given ShapeHitbox.
  void flipHorizontallyAroundHitbox(ShapeHitbox hitboxComponent,
      {bool fromCenter = false}) {
    final center = fromCenter ? 1 : 0;
    final delta = (1 - 2 * anchor.x) *
        (hitboxComponent.position.x * 2 +
            center *
                ((1 - 2 * hitboxComponent.anchor.x) * hitboxComponent.width)) *
        transform.scale.x;
    transform.x += delta * math.cos(transform.angle);
    transform.y += delta * math.sin(transform.angle);
    transform.flipHorizontally();
  }

  /// Flip the component vertically from a given ShapeHitbox.
  void flipVerticallyFromHitbox(ShapeHitbox hitboxComponent) {
    final delta = (1 - 2 * anchor.y) *
        (hitboxComponent.position.y * 2) *
        transform.scale.y;
    transform.x += -delta * math.sin(transform.angle);
    transform.y += delta * math.cos(transform.angle);
    transform.flipVertically();
  }

  /// Flip the component horizontally around the center of a given ShapeHitbox.
  void flipHorizontallyAroundHitboxCenter(ShapeHitbox hitboxComponent) {
    final delta = (1 - 2 * anchor.x) *
        (hitboxComponent.position.x * 2 +
            ((1 - 2 * hitboxComponent.anchor.x) * hitboxComponent.width)) *
        transform.scale.x;
    transform.x += delta * math.cos(transform.angle);
    transform.y += delta * math.sin(transform.angle);
    transform.flipHorizontally();
  }

  /// Flip the component vertically around the center of a given ShapeHitbox.
  void flipVerticallyAroundHitboxCenter(ShapeHitbox hitboxComponent) {
    final delta = (1 - 2 * anchor.y) *
        (hitboxComponent.position.y * 2 +
            ((1 - 2 * hitboxComponent.anchor.y) * hitboxComponent.height)) *
        transform.scale.y;
    transform.x += -delta * math.sin(transform.angle);
    transform.y += delta * math.cos(transform.angle);
    transform.flipVertically();
  }
}
