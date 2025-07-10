extends State
class_name Idle

@export
var fall_state : State
@export 
var jump_state : State
@export
var move_state : State

func enter():
	super()
	parent.animations.play("idle")
	#parent.velocity.x = 0 #Consider using move_toward here to gradually slow player

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		print("JUMP")
		return jump_state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		return move_state
	return null

func process_physics(delta) -> State:
	parent.velocity.y += parent.GRAVITY * delta #var access like this is bad
	
	if !parent.is_on_floor():
		return fall_state
	return null
	
	parent.move_and_slide()
