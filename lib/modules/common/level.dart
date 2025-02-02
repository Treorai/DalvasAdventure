import 'dart:async';

import 'package:dalvas_adventure/modules/collisions/collision_block.dart';
import 'package:dalvas_adventure/modules/common/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String screenName;
  final Player player;

  Level({required this.screenName, required this.player});
  late TiledComponent level;
  List<CollisionBlock> collisionBlocks = [];

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$screenName.tmx', Vector2(32, 32));

    add(level);

    final spawnPointsLayer =
        level.tileMap.getLayer<ObjectGroup>('spawn_points');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer!.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);

            break;
          default:
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');

    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
              isPlatform: true,
            );
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
              position: Vector2(collision.x, collision.y),
              size: Vector2(collision.width, collision.height),
            );
            collisionBlocks.add(block);
            add(block);
        }
      }
    }

    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }
}
