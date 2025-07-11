extends State
class_name Jump

@export
var fall_state : State
@export
var dash_state : State

func enter():
	super()
	parent.velocity.y = parent.jump_velocity
	parent.animations.play("jump")
	
func process_input (event: InputEvent) -> State:
	if Input.is_action_just_pressed("dash"):
		return dash_state
	return null

func process_physics(delta) -> State:
	var input_dir = Input.get_axis("move_left", "move_right")
	parent.animations.flip_h = input_dir == -1 if input_dir != 0 else parent.animations.flip_h
	parent.velocity.x = move_toward(parent.velocity.x, input_dir * parent.maxSpeed, parent.acceleration * delta)
	
	parent.velocity.y += parent.gravity * delta
	
	parent.move_and_slide()
	
	if parent.velocity.y > 0:
		return fall_state
	return null
