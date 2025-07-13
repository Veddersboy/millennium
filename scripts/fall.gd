extends State
class_name Fall

func enter():
	super()
	print(parent.air_friction)
	parent.animations.play("fall")
	
func process_input (input: Node) -> State:
	if Input.is_action_just_pressed("dash") && parent.has_dash:
		return parent.dash_state
	return null

func process_physics(delta) -> State:
	parent.animations.flip_h = input.direction.x == -1 if input.direction.x != 0 else parent.animations.flip_h
	parent.velocity.x = move_toward(parent.velocity.x, input.direction.x * parent.maxSpeed, parent.air_friction * delta)
	parent.velocity.y += parent.gravity * delta
	
	if parent.is_on_floor():
		if input.direction.x != 0 && abs(parent.velocity.x) < parent.minSpeed:
			return parent.idle_state
		else:
			return parent.move_state
	
	parent.move_and_slide()
	return null
