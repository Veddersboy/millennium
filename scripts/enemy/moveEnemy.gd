extends StateEnemy
class_name MoveEnemy

func enter() -> void:
	enemy.animations.play("move")

func physics_process(delta: float) -> void:
	if not enemy.is_on_floor():
		enemy.state_machine.change_state(enemy.fall_state)
		return
	if not enemy.player_chase:
		enemy.state_machine.change_state(enemy.idle_state)
		return

	var direction = sign(enemy.player.global_position.x - enemy.global_position.x)
	enemy.velocity.x = move_toward(enemy.velocity.x, direction * enemy.maxSpeed, enemy.acceleration * delta)
	enemy.move_and_slide()

	
