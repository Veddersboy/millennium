extends StateEnemy
class_name IdleEnemy

@export var friction = 1800

func enter() -> void:
	enemy.animations.play("idle")

func physics_process(delta: float) -> StateEnemy:
	
	
	if enemy.player_chase:
		return enemy.move_state
	elif not enemy.is_on_floor():
		return enemy.fall_state
	
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, friction * delta)
	enemy.move_and_slide()
	
	return null
	
	
