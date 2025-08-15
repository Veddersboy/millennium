extends State
class_name BurnBody

var burn_time: float = 0
var burn_energy_gain = 10
@export var burn_duration: float = 0.5

func enter():
	super()
	burn_time = 0
	
	get_tree().call_group("toBurn", "ignite")
	
	parent.add_energy(burn_energy_gain)

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
