extends State
class_name Idle

func enter():
	super()
	parent.animations.play("idle")
	#parent.velocity.x = 0 #Consider using move_toward here to gradually slow player

func process_input(input: Node) -> State:
	if input.jump_pressed and parent.is_on_floor():
		return parent.jump_state
	if input.direction.x != 0:
		return parent.move_state
	if input.dash_pressed && parent.has_dash:
		return parent.dash_state
	return null

func process_physics(delta) -> State:
	parent.velocity.y += parent.gravity * delta
	
	if !parent.is_on_floor():
		return parent.fall_state
	parent.velocity.x = move_toward(parent.velocity.x, 0, parent.friction * delta)
	parent.move_and_slide()
	return null
