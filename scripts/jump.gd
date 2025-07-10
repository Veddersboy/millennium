extends State
class_name Jump

@export
var fall_state : State

func enter():
	super()
	parent.velocity.y = parent.jump_velocity
	parent.animations.play("jump")

func process_physics(delta) -> State:
	var input_dir = Input.get_axis("move_left", "move_right")
	parent.velocity.x = move_toward(parent.velocity.x, input_dir * parent.maxSpeed, parent.acceleration * delta)
	
	parent.velocity.y += parent.gravity * delta
	
	parent.move_and_slide()
	
	if parent.velocity.y > 0:
		return fall_state
	return null
