extends State
class_name Move

@export
var fall_state : State
@export 
var jump_state : State
@export
var idle_state : State

func enter():
	super()
	parent.animations.play("move_right")

func process_input (event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		print("JUMP")
		return jump_state
	return null

func process_physics(delta) -> State:
	#State Switches
	if !parent.is_on_floor():
		return fall_state
	
	parent.animations.flip_v = false
	#Velocity application if state remains
	var input_dir = Input.get_axis("move_left", "move_right")
	if input_dir == 0:
		if abs(parent.velocity.x) < parent.minSpeed:
			return idle_state
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction * delta)
	else:
		if((input_dir == 1.0) == parent.animations.flip_h):
			parent.animations.flip_h = !parent.animations.flip_h
		parent.velocity.x = move_toward(parent.velocity.x, input_dir * parent.maxSpeed, parent.acceleration * delta)
	parent.move_and_slide()
	return null
