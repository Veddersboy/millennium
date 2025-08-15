extends StateEnemy
class_name BurnedEnemy

@export var burn_duration: float = 2.0
@export var burn_energy_gain: float = 5

var burn_timer: float = 0.0

func enter():
	super()
	burn_timer = burn_duration
	enemy.animations.play("burn")

func process_frame(delta: float) -> StateEnemy:
	burn_timer -= delta
	
	if burn_timer <= 0:
		enemy.queue_free()
	return null
