extends State
class_name Jump

func enter():
	parent.velocity.y = parent.jump_velocity
	parent.animations.play("jump")

func process_physics(delta):
	var input_dir = Input.get_axis("move_right", "move_left")
	parent.velocity.x = move_toward(parent.velocity.x, input_dir * parent.maxSpeed, parent.acceleration * delta)
	
	parent.velocity.y += parent.GRAVITY * delta
	
	parent.move_and_slide()
	
	if parent.velocity.y > 0:
		parent.state_machine.change_state(parent.fall_state)
