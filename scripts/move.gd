extends State
class_name Move

func enter():
	super()
	parent.animations.play("move_right")

func process_input (input: Node) -> State:
	if input.jump_pressed and parent.is_on_floor():
		return parent.jump_state
	if Input.is_action_just_pressed("dash"):
		return parent.dash_state
	return null

func process_physics(delta) -> State:
	#State Switches
	if !parent.is_on_floor():
		return parent.fall_state
	
	parent.animations.flip_v = false
	#Velocity application if state remains
	if input.direction.x == 0:
		if abs(parent.velocity.x) < parent.minSpeed:
			return parent.idle_state
		parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction * delta)
	else:
		parent.animations.flip_h = input.direction.x == -1 if input.direction.x != 0 else parent.animations.flip_h
		parent.velocity.x = move_toward(parent.velocity.x, input.direction.x * parent.maxSpeed, parent.acceleration * delta)
	parent.move_and_slide()
	return null
