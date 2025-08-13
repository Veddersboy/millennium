extends StateEnemy
class_name FallEnemy

func enter() -> void:
	enemy.animations.play("fall")

func physics_process(delta: float) -> StateEnemy:
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	if enemy.is_on_floor():
		if enemy.player_chase:
			return enemy.move_state
		else:
			return enemy.idle_state
	return null
