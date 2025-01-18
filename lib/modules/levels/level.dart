import 'dart:async';

import 'package:dalvas_adventure/modules/actors/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {
  final String screenName;
  Level({required this.screenName});
  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$screenName.tmx', Vector2(32, 32));

    add(level);

    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('spawn_points');

    for(final spawnPoint in spawnPointsLayer!.objects) {
      switch (spawnPoint.class_) {
        case 'Player':
          final player = Player(entity: 'King', position: Vector2(spawnPoint.x, spawnPoint.y));
          add(player);
        break;
      }
    }

    return super.onLoad();
  }
}
