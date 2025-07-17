extends StateEnemy
class_name FallEnemy

func enter() -> void:
	enemy.animations.play("fall")

func physics_process(delta: float) -> void:
	enemy.velocity.y += enemy.gravity * delta
	enemy.move_and_slide()

	if enemy.is_on_floor():
		if enemy.player_chase:
			enemy.state_machine.change_state(enemy.move_state)
		else:
			enemy.state_machine.change_state(enemy.idle_state)
