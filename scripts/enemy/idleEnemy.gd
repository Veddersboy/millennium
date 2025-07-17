extends StateEnemy
class_name IdleEnemy

func enter() -> void:
	enemy.animations.play("idle")

func physics_process(delta: float) -> void:
	# Example transition logic
	if enemy.player_chase:
		enemy.state_machine.change_state(enemy.move_state)
	elif not enemy.is_on_floor():
		enemy.state_machine.change_state(enemy.fall_state)
