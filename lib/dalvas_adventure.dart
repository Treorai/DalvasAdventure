import 'dart:async';
import 'dart:ui' show Color;

import 'package:dalvas_adventure/modules/levels/level.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class DalvasAdventure extends FlameGame {
  @override
  Color backgroundColor() => const Color.fromARGB(255, 63, 56, 81);

  late final CameraComponent cam;
  
  @override
  final world = Level(screenName: 'screen-00');

  @override
  FutureOr<void> onLoad() async {
    //TODO: await images.loadAll(fileNames);
    await images.loadAllImages();

    cam = CameraComponent.withFixedResolution(
        world: world, width: 1280, height: 768);
    cam.viewfinder.anchor = Anchor.topLeft;
    addAll([cam, world]);

    return super.onLoad();
  }
}
