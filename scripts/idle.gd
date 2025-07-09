extends State
class_name Idle

@export
var Fall : State
@export 
var Jump : State
@export
var Move : State

func enter():
	parent.animations.play("idle")
	parent.velocity.x = 0
	#parent.velocity.x = 0 #Consider using move_toward here to gradually slow player

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and parent.is_on_floor():
		print("JUMP")
		parent.state_machine.change_state(Jump)
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		parent.state_machine.change_state(Move)
		return Move
	return null

func process_physics(delta):
	parent.velocity.y += parent.GRAVITY * delta #var access like this is bad
	
	if !parent.is_on_floor():
		parent.state_machine.change_state(Fall)
	return null
	
	parent.move_and_slide()
