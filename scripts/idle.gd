extends State
class_name Idle

@export
var fall_state : State
@export 
var jump_state : State
@export
var move_state : State
@export
var dash_state : State

func enter():
	super()
	parent.animations.play("idle")
	#parent.velocity.x = 0 #Consider using move_toward here to gradually slow player

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		return jump_state
	if Input.get_axis("move_left","move_right") != 0:
		return move_state
	if Input.is_action_just_pressed("dash"):
		return dash_state
	return null

func process_physics(delta) -> State:
	parent.velocity.y += parent.gravity * delta #var access like this is bad
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
	parent.move_and_slide()
