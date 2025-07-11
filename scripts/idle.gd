extends State
class_name Idle

func enter():
	super()
	parent.animations.play("idle")
	#parent.velocity.x = 0 #Consider using move_toward here to gradually slow player

func process_input(input: Node) -> State:
	if input.jump_pressed and parent.is_on_floor():
		return parent.jump_state
	if Input.get_axis("move_left","move_right") != 0:
		return parent.move_state
	if Input.is_action_just_pressed("dash"):
		return parent.dash_state
	return null

func process_physics(delta) -> State:
	parent.velocity.y += parent.gravity * delta #var access like this is bad
	
	if !parent.is_on_floor():
		return parent.fall_state
	return null
	
	parent.move_and_slide()
