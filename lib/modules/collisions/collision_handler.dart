bool checkCollision(player, object) {
  final fixedX = player.scale.x < 0 ? player.position.x - player.width : player.position.x;
  final fixedY = object.isPlatform ? player.position.y + player.height : player.position.y;
  
  return (fixedY < object.y + object.height &&
        player.position.y + player.height > object.y &&
        fixedX < object.x + object.width &&
        fixedX + player.width > object.x);
}