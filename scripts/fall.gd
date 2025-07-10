extends State
class_name Fall

@export
var idle_state: State
@export
var move_state: State
@export
var minSpeed : float = 0.005

func enter():
	super()
	parent.animations.play("fall")

func process_physics(delta) -> State:
	var input_dir = Input.get_axis("move_left", "move_right")
	parent.velocity.x = move_toward(parent.velocity.x, input_dir * parent.maxSpeed, parent.acceleration * delta)
	parent.velocity.y += parent.gravity * delta
	
	if parent.is_on_floor():
		if input_dir != 0 && abs(parent.velocity.x) < minSpeed:
			return idle_state
		else:
			return move_state
	
	parent.move_and_slide()
	return null
