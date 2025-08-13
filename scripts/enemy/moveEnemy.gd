extends StateEnemy
class_name MoveEnemy

func enter() -> void:
	enemy.animations.play("idle")

func physics_process(delta: float) -> StateEnemy:
	if not enemy.is_on_floor():
		return enemy.fall_state
	if not enemy.player_chase:
		return enemy.idle_state
		
	var direction = sign(enemy.player.global_position.x - enemy.global_position.x)
	enemy.velocity.x = move_toward(enemy.velocity.x, direction * enemy.maxSpeed, enemy.acceleration * delta)
	enemy.move_and_slide()
	
	return null
