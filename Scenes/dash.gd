extends State
class_name dash

@export
var idle_state: State
@export
var move_state: State
@export
var fall_state: State

var dash_time: float = 0

func enter():
	super()
	dash_time = 0
	parent.animations.play("dash")
	var input_dir = Input.get_axis("move_left", "move_right")
	if input_dir != 0:
		parent.animations.flip_h = input_dir == -1
		parent.velocity.x = parent.dash_speed * input_dir
	else:
		parent.velocity.x = parent.dash_speed * (1 if !parent.animations.flip_h else -1)
	parent.velocity.y = 0 #Horizontal Dash only atm

func process_physics(delta) -> State:
	dash_time += delta
	if dash_time > parent.dash_length:
		return idle_state #Consider making a function to decide transition state within state manager or something
	parent.move_and_slide()
	return null
