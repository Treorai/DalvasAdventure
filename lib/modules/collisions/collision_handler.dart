bool checkCollision(player, object) {
  final fixedX = player.scale.x < 0
      ? player.position.x - player.hitbox.position.x - player.hitbox.width
      : player.position.x + player.hitbox.position.x;
  final fixedY = object.isPlatform
      ? player.position.y + player.hitbox.position.y + player.hitbox.height
      : player.position.y + player.hitbox.position.y;  

  return (fixedY < object.y + object.height &&
      player.position.y + player.hitbox.position.y + player.hitbox.height >
          object.y &&
      fixedX < object.x + object.width &&
      fixedX + player.hitbox.width > object.x);
}
