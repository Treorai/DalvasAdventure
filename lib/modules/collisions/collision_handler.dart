bool checkCollision(player, object) {
  final fixedX = player.scale.x < 0
      ? player.position.x - player.hitbox.offsetX - player.hitbox.width
      : player.position.x + player.hitbox.offsetX;
  final fixedY = object.isPlatform
      ? player.position.y + player.hitbox.offsetY + player.hitbox.height
      : player.position.y + player.hitbox.offsetY;

  return (fixedY < object.y + object.height &&
      player.position.y + player.hitbox.offsetY + player.hitbox.height >
          object.y &&
      fixedX < object.x + object.width &&
      fixedX + player.hitbox.width > object.x);
}
