extends State
class_name Idle

func enter():
	parent.animations.play("idle_right")

func process_physics(delta):
	if !parent.is_on_floor():
		parent.state_machine.change_state(parent.fall_state)
		return

	var input_dir = Input.get_axis("move_left", "move_right")
	if input_dir != 0:
		parent.state_machine.change_state(parent.move_state)
	elif Input.is_action_just_pressed("jump"):
		parent.state_machine.change_state(parent.jump_state)
