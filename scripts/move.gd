extends State
class_name Move

func enter():
	parent.animations.play("move_right")

func process_physics(delta):
	if !parent.is_on_floor():
		parent.state_machine.change_state(parent.fall_state)
		return

	var input_dir = Input.get_axis("move_left", "move_right")
	if input_dir == 0:
		parent.state_machine.change_state(parent.idle_state)
		return

	parent.velocity.x = move_toward(parent.velocity.x, input_dir * parent.maxSpeed, parent.acceleration * delta)
	parent.move_and_slide()
