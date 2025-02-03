import 'dart:io' as dio show Platform;

import 'package:dalvas_adventure/dalvas_adventure.dart';
import 'package:flame/flame.dart' show Flame;
import 'package:flame/game.dart' show GameWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mobile Settings
  if (!dio.Platform.isWindows) {
    await Flame.device.fullScreen();
    await Flame.device.setLandscape();
  }

  // Run
  DalvasAdventure game = DalvasAdventure();

  // Recreates the game instance if kDebugMode == True
  runApp(GameWidget(game: kDebugMode ? DalvasAdventure() : game));
}
