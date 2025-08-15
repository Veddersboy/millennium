extends State
class_name BurnBody

var burn_time: float = 0
@export var burn_duration: float = 0.5

func enter():
	super()
	burn_time = 0
	#parent.animations.play("burn")

func process_physics(delta) -> State:
	burn_time += delta
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if input.direction.x != 0:
			return parent.move_state
		else:
			return parent.idle_state
	else:
		return parent.fall_state
	
	return null

func exit():
	pass
